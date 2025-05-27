import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationController extends GetxController {
  var currentPosition = Rxn<Position>();
  var isLocationEnabled = false.obs;
  var isLoading = false.obs;
  var permissionStatus = Rx<PermissionStatus>(PermissionStatus.denied);

  @override
  void onInit() {
    super.onInit();
    checkLocationPermission();
  }

  Future<void> checkLocationPermission() async {
    try {
      var status = await Permission.location.status;
      permissionStatus.value = status;

      if (!status.isGranted) {
        status = await Permission.location.request();
        permissionStatus.value = status;
      }

      if (status.isGranted) {
        await getCurrentLocation();
      } else {
        Get.snackbar(
          'Permission Required',
          'Location permission is needed for delivery assignment',
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      print('Error checking location permission: $e');
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        isLocationEnabled.value = false;
        Get.snackbar(
          'Location Services Disabled',
          'Please enable location services to continue',
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Permission Denied',
            'Location permission is required for this app to work',
            backgroundColor: Get.theme.colorScheme.error,
            colorText: Get.theme.colorScheme.onError,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Permission Permanently Denied',
          'Please enable location permission from app settings',
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentPosition.value = position;
      isLocationEnabled.value = true;

      print('Current location: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      print('Error getting location: $e');
      Get.snackbar(
        'Location Error',
        'Failed to get current location: ${e.toString()}',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshLocation() async {
    await getCurrentLocation();
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth radius in kilometers

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  String formatDistance(double distanceInKm) {
    if (distanceInKm < 1) {
      return '${(distanceInKm * 1000).round()} m';
    } else {
      return '${distanceInKm.toStringAsFixed(1)} km';
    }
  }

  int estimateDeliveryTime(double distanceInKm) {
    // Estimate delivery time based on distance
    // Assuming average speed of 20 km/h in city traffic
    double timeInHours = distanceInKm / 20;
    int timeInMinutes = (timeInHours * 60).round();
    return timeInMinutes < 5 ? 5 : timeInMinutes; // Minimum 5 minutes
  }

  bool isWithinRadius(
      double lat1, double lon1, double lat2, double lon2, double radiusKm) {
    double distance = calculateDistance(lat1, lon1, lat2, lon2);
    return distance <= radiusKm;
  }
}
