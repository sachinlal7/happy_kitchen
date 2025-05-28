import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:happy_kitchen_delivery/models/delivery_partner_model.dart';
import 'package:happy_kitchen_delivery/models/order_model.dart';
import 'package:happy_kitchen_delivery/utils/demo_data.dart';

import 'location_controller.dart';

class DeliveryPartnerController extends GetxController {
  final LocationController locationController = Get.put(LocationController());

  var deliveryPartners = <DeliveryPartner>[].obs;
  var availablePartners = <DeliveryPartner>[].obs;
  var currentOrder = Rxn<Order>();
  var hasActiveOrder = false.obs;
  var selectedPartnerId = ''.obs;
  var isOnline = true.obs;
  var todayEarnings = 0.0.obs;
  var todayOrders = 0.obs;
  var currentRating = 4.8.obs;
  var searchRadius = 1.0.obs; // Default 1km radius
  var currentLocation = Rxn<Position>();

  Timer? _orderTimeoutTimer;
  Timer? _realTimeUpdateTimer;
  Timer? _locationUpdateTimer;

  @override
  void onInit() {
    super.onInit();
    generateMockDeliveryPartners();
    startRealTimeUpdates();
  }

  @override
  void onClose() {
    _orderTimeoutTimer?.cancel();
    _realTimeUpdateTimer?.cancel();
    super.onClose();
  }

  void generateMockDeliveryPartners() {
    deliveryPartners.value = DemoData.generateMockPartners();
    print('Generated ${deliveryPartners.length} mock delivery partners');
  }

  List<DeliveryPartner> findNearbyPartners(
      double customerLat, double customerLng,
      {double radiusKm = 1.0}) {
    List<DeliveryPartner> nearbyPartners = deliveryPartners.where((partner) {
      if (!partner.isAvailable) return false;

      double distance = locationController.calculateDistance(
        customerLat,
        customerLng,
        partner.latitude,
        partner.longitude,
      );

      return distance <= radiusKm;
    }).toList();

    nearbyPartners.sort((a, b) {
      double distanceA = locationController.calculateDistance(
          customerLat, customerLng, a.latitude, a.longitude);
      double distanceB = locationController.calculateDistance(
          customerLat, customerLng, b.latitude, b.longitude);

      int distanceComparison = distanceA.compareTo(distanceB);
      if (distanceComparison != 0) return distanceComparison;
      return b.rating.compareTo(a.rating);
    });

    return nearbyPartners;
  }

  void notifyPartnersAboutOrder(Order order) {
    List<DeliveryPartner> nearbyPartners = findNearbyPartners(
      order.customerLatitude,
      order.customerLongitude,
    );

    availablePartners.value = nearbyPartners;
    currentOrder.value = order;

    if (nearbyPartners.isEmpty) {
      Get.snackbar(
        'No Partners Available',
        'No delivery partners found within 1km radius',
        backgroundColor: Colors.orange[600],
        colorText: Colors.white,
        duration: Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    startOrderTimeout();

    Get.snackbar(
      '📢 Order Broadcast!',
      '${nearbyPartners.length} delivery partners notified nearby',
      backgroundColor: Colors.green[600],
      colorText: Colors.white,
      duration: Duration(seconds: 4),
      snackPosition: SnackPosition.TOP,
      icon: Icon(Icons.notifications_active, color: Colors.white),
    );

    _simulateNotificationSound();
  }

  void acceptOrder(String partnerId) {
    if (currentOrder.value != null && !hasActiveOrder.value) {
      hasActiveOrder.value = true;
      selectedPartnerId.value = partnerId;
      currentOrder.value!.status = 'accepted';
      currentOrder.value!.assignedPartnerId = partnerId;

      cancelOrderTimeout();

      availablePartners.clear();

      _updatePartnerAvailability(partnerId, false);

      todayOrders.value++;

      DeliveryPartner? partner = getPartnerById(partnerId);
      Get.snackbar(
        '🎉 Order Accepted!',
        'Order assigned to ${partner?.name ?? 'Partner'}',
        backgroundColor: Colors.orange[600],
        colorText: Colors.white,
        duration: Duration(seconds: 4),
        snackPosition: SnackPosition.TOP,
        icon: Icon(Icons.check_circle, color: Colors.white),
      );

      _simulateDeliveryProcess();
    } else {
      Get.snackbar(
        'Order Already Taken',
        'This order has been accepted by another partner',
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  void declineOrder() {
    if (currentOrder.value != null && !hasActiveOrder.value) {
      availablePartners
          .removeWhere((partner) => partner.id == selectedPartnerId.value);

      Get.snackbar(
        'Order Declined',
        'Looking for other available partners...',
        backgroundColor: Colors.grey[600],
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      if (availablePartners.isEmpty) {
        currentOrder.value = null;
        cancelOrderTimeout();
      }
    }
  }

  void completeOrder() {
    if (hasActiveOrder.value && currentOrder.value != null) {
      double orderEarnings = currentOrder.value!.totalAmount * 0.1;
      todayEarnings.value += orderEarnings;

      if (selectedPartnerId.value.isNotEmpty) {
        _updatePartnerAvailability(selectedPartnerId.value, true);
      }

      hasActiveOrder.value = false;
      selectedPartnerId.value = '';
      currentOrder.value = null;

      Get.snackbar(
        '✅ Delivery Completed!',
        'Great job! You earned ₹${orderEarnings.toStringAsFixed(0)}',
        backgroundColor: Colors.green[600],
        colorText: Colors.white,
        duration: Duration(seconds: 4),
        snackPosition: SnackPosition.TOP,
        icon: Icon(Icons.monetization_on, color: Colors.white),
      );
    }
  }

  DeliveryPartner? getPartnerById(String id) {
    try {
      return deliveryPartners.firstWhere((partner) => partner.id == id);
    } catch (e) {
      return null;
    }
  }

  void toggleOnlineStatus() {
    isOnline.value = !isOnline.value;

    Get.snackbar(
      isOnline.value ? '🟢 You\'re Online!' : '🔴 You\'re Offline',
      isOnline.value
          ? 'You will receive new order notifications'
          : 'You won\'t receive new orders until you go online',
      backgroundColor: isOnline.value ? Colors.green[600] : Colors.grey[600],
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

  void _updatePartnerAvailability(String partnerId, bool isAvailable) {
    int index = deliveryPartners.indexWhere((p) => p.id == partnerId);
    if (index != -1) {
      deliveryPartners[index] = deliveryPartners[index].copyWith(
        isAvailable: isAvailable,
      );
    }
  }

  void startOrderTimeout() {
    _orderTimeoutTimer = Timer(Duration(seconds: 45), () {
      if (currentOrder.value != null && !hasActiveOrder.value) {
        Get.snackbar(
          '⏰ Order Timeout',
          'Searching for additional delivery partners...',
          backgroundColor: Colors.orange[600],
          colorText: Colors.white,
          duration: Duration(seconds: 4),
        );

        _expandSearchRadius();
      }
    });
  }

  void cancelOrderTimeout() {
    _orderTimeoutTimer?.cancel();
  }

  void _expandSearchRadius() {
    if (currentOrder.value != null) {
      List<DeliveryPartner> expandedPartners = findNearbyPartners(
        currentOrder.value!.customerLatitude,
        currentOrder.value!.customerLongitude,
        radiusKm: 2.0, // Expand to 2km
      );

      for (DeliveryPartner partner in expandedPartners) {
        if (!availablePartners.any((p) => p.id == partner.id)) {
          availablePartners.add(partner);
        }
      }

      if (availablePartners.isNotEmpty) {
        Get.snackbar(
          '📡 Expanded Search',
          'Found ${availablePartners.length} partners within 2km',
          backgroundColor: Colors.blue[600],
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
    }
  }

  void startRealTimeUpdates() {
    _realTimeUpdateTimer = Timer.periodic(Duration(seconds: 20), (timer) {
      if (!hasActiveOrder.value && Random().nextBool()) {
        _simulateRandomOrder();
      }
    });
  }

  void _simulateRandomOrder() {
    if (currentOrder.value == null && isOnline.value) {
      Order demoOrder = DemoData.generateRandomOrder();
      notifyPartnersAboutOrder(demoOrder);
    }
  }

  void _simulateNotificationSound() {
    print('🔔 Notification sound played');
  }

  void _simulateDeliveryProcess() {
    Timer(Duration(seconds: 5), () {
      if (hasActiveOrder.value) {
        Get.snackbar(
          '🏍️ On the way to restaurant',
          'Estimated pickup time: 8 minutes',
          backgroundColor: Colors.blue[600],
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
    });

    Timer(Duration(seconds: 15), () {
      if (hasActiveOrder.value) {
        Get.snackbar(
          '📦 Order picked up',
          'Heading to customer location',
          backgroundColor: Colors.green[600],
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
    });
  }

  Map<String, dynamic> getTodayStats() {
    return {
      'orders': todayOrders.value,
      'earnings': todayEarnings.value,
      'rating': currentRating.value,
      'hoursWorked': 8.5, // Mock data
    };
  }

  List<Map<String, dynamic>> getWeeklyStats() {
    return [
      {'day': 'Mon', 'orders': 12, 'earnings': 450.0},
      {'day': 'Tue', 'orders': 15, 'earnings': 520.0},
      {'day': 'Wed', 'orders': 18, 'earnings': 680.0},
      {'day': 'Thu', 'orders': 14, 'earnings': 580.0},
      {'day': 'Fri', 'orders': 20, 'earnings': 750.0},
      {'day': 'Sat', 'orders': 25, 'earnings': 920.0},
      {'day': 'Sun', 'orders': 16, 'earnings': 600.0},
    ];
  }
}
