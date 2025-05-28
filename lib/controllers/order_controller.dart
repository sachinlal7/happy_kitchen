import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_kitchen_delivery/models/order_model.dart';
import 'package:happy_kitchen_delivery/utils/demo_data.dart';

import 'delivery_partner_controller.dart';
import 'location_controller.dart';

class OrderController extends GetxController {
  final DeliveryPartnerController partnerController =
      Get.put(DeliveryPartnerController());
  final LocationController locationController = Get.put(LocationController());

  var orders = <Order>[].obs;
  var activeOrders = <Order>[].obs;
  var completedOrders = <Order>[].obs;
  var isCreatingOrder = false.obs;
  var todayOrderCount = 0.obs;
  var todayRevenue = 0.0.obs;
  var averageDeliveryTime = 25.0.obs; // minutes

  Timer? _orderStatusTimer;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
    startOrderStatusUpdates();
  }

  @override
  void onClose() {
    _orderStatusTimer?.cancel();
    super.onClose();
  }

  void loadInitialData() {
    _generateSampleHistoricalOrders();
  }

  void createOrder({
    required String customerName,
    required String customerAddress,
    required double customerLatitude,
    required double customerLongitude,
    required List<OrderItem> items,
  }) async {
    try {
      isCreatingOrder.value = true;

      String orderId = 'HK${DateTime.now().millisecondsSinceEpoch}';
      double totalAmount =
          items.fold(0, (sum, item) => sum + (item.price * item.quantity));

      Order newOrder = Order(
        id: orderId,
        customerName: customerName,
        customerAddress: customerAddress,
        customerLatitude: customerLatitude,
        customerLongitude: customerLongitude,
        items: items,
        totalAmount: totalAmount,
        createdAt: DateTime.now(),
      );

      orders.insert(0, newOrder);
      activeOrders.insert(0, newOrder);

      todayOrderCount.value++;
      todayRevenue.value += totalAmount;

      partnerController.notifyPartnersAboutOrder(newOrder);

      Get.snackbar(
        '🎉 Order Created Successfully!',
        'Order #${orderId.substring(orderId.length - 6)} - ₹${totalAmount.toStringAsFixed(0)}',
        backgroundColor: Colors.blue[600],
        colorText: Colors.white,
        duration: Duration(seconds: 4),
        snackPosition: SnackPosition.TOP,
        icon: Icon(Icons.receipt_long, color: Colors.white),
      );

      _monitorOrderStatus(newOrder);
    } catch (e) {
      Get.snackbar(
        'Error Creating Order',
        'Failed to create order: ${e.toString()}',
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } finally {
      isCreatingOrder.value = false;
    }
  }

  void generateSampleOrder() {
    Order sampleOrder = DemoData.generateRandomOrder();

    createOrder(
      customerName: sampleOrder.customerName,
      customerAddress: sampleOrder.customerAddress,
      customerLatitude: sampleOrder.customerLatitude,
      customerLongitude: sampleOrder.customerLongitude,
      items: sampleOrder.items,
    );
  }

  void updateOrderStatus(String orderId, String newStatus) {
    int orderIndex = orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      orders[orderIndex].status = newStatus;
      orders.refresh();

      if (newStatus == 'delivered') {
        Order completedOrder = orders[orderIndex];
        activeOrders.removeWhere((order) => order.id == orderId);
        completedOrders.insert(0, completedOrder);

        _updateDeliveryStats(completedOrder);
      }
    }
  }

  void cancelOrder(String orderId) {
    Order? order = getOrderById(orderId);
    if (order != null && order.status == 'pending') {
      order.status = 'cancelled';
      activeOrders.removeWhere((o) => o.id == orderId);
      orders.refresh();

      Get.snackbar(
        'Order Cancelled',
        'Order #${orderId.substring(orderId.length - 6)} has been cancelled',
        backgroundColor: Colors.orange[600],
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  Order? getOrderById(String orderId) {
    try {
      return orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  List<Order> getOrdersByStatus(String status) {
    return orders.where((order) => order.status == status).toList();
  }

  List<Order> getTodayOrders() {
    DateTime today = DateTime.now();
    return orders.where((order) {
      return order.createdAt.year == today.year &&
          order.createdAt.month == today.month &&
          order.createdAt.day == today.day;
    }).toList();
  }

  Map<String, dynamic> getOrderStatistics() {
    List<Order> todayOrders = getTodayOrders();
    List<Order> pendingOrders = getOrdersByStatus('pending');
    List<Order> acceptedOrders = getOrdersByStatus('accepted');
    List<Order> deliveredOrders = getOrdersByStatus('delivered');

    return {
      'total': orders.length,
      'today': todayOrders.length,
      'pending': pendingOrders.length,
      'accepted': acceptedOrders.length,
      'delivered': deliveredOrders.length,
      'revenue': todayRevenue.value,
    };
  }

  List<Map<String, dynamic>> getHourlyOrderData() {
    // Generate hourly order data for charts
    List<Map<String, dynamic>> hourlyData = [];
    List<Order> todayOrders = getTodayOrders();

    for (int hour = 0; hour < 24; hour++) {
      int orderCount = todayOrders.where((order) {
        return order.createdAt.hour == hour;
      }).length;

      hourlyData.add({
        'hour': hour,
        'orders': orderCount,
        'timeLabel': '${hour.toString().padLeft(2, '0')}:00',
      });
    }

    return hourlyData;
  }

  void _monitorOrderStatus(Order order) {
    // Simulate order status updates for demo
    Timer(Duration(seconds: 10), () {
      if (order.status == 'pending') {
        // Simulate restaurant confirmation
        updateOrderStatus(order.id, 'confirmed');
        Get.snackbar(
          '👨‍🍳 Order Confirmed',
          'Restaurant confirmed order #${order.id.substring(order.id.length - 6)}',
          backgroundColor: Colors.green[600],
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
    });
  }

  void startOrderStatusUpdates() {
    _orderStatusTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      _updateActiveOrderStatuses();
    });
  }

  void _updateActiveOrderStatuses() {
    for (Order order in activeOrders) {
      if (order.status == 'accepted') {
        // Simulate delivery progress
        Random random = Random();
        if (random.nextDouble() < 0.3) {
          // 30% chance
          _simulateDeliveryProgress(order);
        }
      }
    }
  }

  void _simulateDeliveryProgress(Order order) {
    List<String> progressMessages = [
      'Partner is heading to restaurant',
      'Order being prepared',
      'Order picked up, heading to customer',
      'Partner is nearby',
    ];

    String message =
        progressMessages[Random().nextInt(progressMessages.length)];

    Get.snackbar(
      '📍 Delivery Update',
      'Order #${order.id.substring(order.id.length - 6)}: $message',
      backgroundColor: Colors.blue[600],
      colorText: Colors.white,
      duration: Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _updateDeliveryStats(Order completedOrder) {
    int deliveryTimeMinutes = 20 + Random().nextInt(20); // 20-40 minutes

    double currentAvg = averageDeliveryTime.value;
    int completedCount = completedOrders.length;
    averageDeliveryTime.value =
        ((currentAvg * (completedCount - 1)) + deliveryTimeMinutes) /
            completedCount;

    Get.snackbar(
      '✅ Order Delivered',
      'Completed in $deliveryTimeMinutes minutes',
      backgroundColor: Colors.green[600],
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

  void _generateSampleHistoricalOrders() {
    Random random = Random();
    DateTime now = DateTime.now();

    for (int i = 0; i < 10; i++) {
      DateTime orderTime = now.subtract(Duration(
        hours: random.nextInt(48),
        minutes: random.nextInt(60),
      ));

      Order historicalOrder = Order(
        id: 'HK${orderTime.millisecondsSinceEpoch}',
        customerName: DemoData
            .customerNames[random.nextInt(DemoData.customerNames.length)],
        customerAddress:
            DemoData.addresses[random.nextInt(DemoData.addresses.length)],
        customerLatitude: 28.6139 + (random.nextDouble() - 0.5) * 0.05,
        customerLongitude: 77.2090 + (random.nextDouble() - 0.5) * 0.05,
        items: DemoData.menuItems[random.nextInt(DemoData.menuItems.length)],
        totalAmount: 200 + random.nextDouble() * 800,
        createdAt: orderTime,
        status: 'delivered',
      );

      orders.add(historicalOrder);
      completedOrders.add(historicalOrder);
    }

    List<Order> todayHistorical = getTodayOrders();
    todayOrderCount.value += todayHistorical.length;
    todayRevenue.value +=
        todayHistorical.fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  void updateRestaurantStatus(bool isOpen) {
    Get.snackbar(
      isOpen ? '🟢 Restaurant Open' : '🔴 Restaurant Closed',
      isOpen ? 'Now accepting new orders' : 'Not accepting orders temporarily',
      backgroundColor: isOpen ? Colors.green[600] : Colors.red[600],
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

  void setEstimatedPrepTime(int minutes) {
    Get.snackbar(
      '⏱️ Prep Time Updated',
      'Estimated preparation time: $minutes minutes',
      backgroundColor: Colors.blue[600],
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

  Map<String, dynamic> getDashboardData() {
    return {
      'todayOrders': todayOrderCount.value,
      'todayRevenue': todayRevenue.value,
      'averageOrderValue': todayOrderCount.value > 0
          ? todayRevenue.value / todayOrderCount.value
          : 0.0,
      'activeOrders': activeOrders.length,
      'averageDeliveryTime': averageDeliveryTime.value,
      'hourlyData': getHourlyOrderData(),
    };
  }

  List<Map<String, dynamic>> getTopItems() {
    Map<String, int> itemCount = {};
    Map<String, double> itemRevenue = {};

    for (Order order in orders) {
      for (OrderItem item in order.items) {
        itemCount[item.name] = (itemCount[item.name] ?? 0) + item.quantity;
        itemRevenue[item.name] =
            (itemRevenue[item.name] ?? 0) + (item.price * item.quantity);
      }
    }

    List<Map<String, dynamic>> topItems = [];
    itemCount.forEach((name, count) {
      topItems.add({
        'name': name,
        'count': count,
        'revenue': itemRevenue[name] ?? 0.0,
      });
    });

    topItems.sort((a, b) => b['count'].compareTo(a['count']));
    return topItems.take(5).toList();
  }
}
