import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/delivery_partner_controller.dart';
import '../controllers/location_controller.dart';
import '../widgets/animated_map_marker.dart';
import '../widgets/order_tracking_map.dart';

class DeliveryPartnerScreen extends StatelessWidget {
  final DeliveryPartnerController partnerController = Get.find();
  final LocationController locationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delivery Partner',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.green[600],
        elevation: 0,
        actions: [
          Obx(() => Switch(
                value: partnerController.isOnline.value,
                onChanged: (value) => partnerController.toggleOnlineStatus(),
                activeColor: Colors.white,
              )),
          SizedBox(width: 10),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[600]!, Colors.green[50]!],
          ),
        ),
        child: Column(
          children: [
            // Partner Status Card
            Container(
              margin: EdgeInsets.all(20),
              child: Obx(() => _buildPartnerStatusCard()),
            ),

            // Main Content Area
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Available Orders',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Obx(() => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: partnerController
                                          .availablePartners.isNotEmpty
                                      ? Colors.orange[100]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 14,
                                      color: partnerController
                                              .availablePartners.isNotEmpty
                                          ? Colors.orange[700]
                                          : Colors.grey[600],
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '${partnerController.availablePartners.length} nearby',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: partnerController
                                                .availablePartners.isNotEmpty
                                            ? Colors.orange[700]
                                            : Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Obx(() => _buildMainContent()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(() => partnerController.hasActiveOrder.value
          ? FloatingActionButton.extended(
              onPressed: () => _showTrackingDetails(context),
              backgroundColor: Colors.blue[600],
              icon: Icon(Icons.navigation),
              label: Text('Track Order'),
            )
          : SizedBox.shrink()),
    );
  }

  Widget _buildPartnerStatusCard() {
    Map<String, dynamic> stats = partnerController.getTodayStats();

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Row
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green[100],
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.green[600],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: partnerController.isOnline.value
                            ? Colors.green
                            : Colors.grey,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Demo Partner',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.motorcycle,
                            size: 16, color: Colors.grey[600]),
                        SizedBox(width: 4),
                        Text(
                          'Bike',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        Text(
                          ' ${stats['rating']}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: partnerController.isOnline.value
                      ? Colors.green[100]
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  partnerController.isOnline.value ? 'ONLINE' : 'OFFLINE',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: partnerController.isOnline.value
                        ? Colors.green[700]
                        : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Today\'s Orders',
                  '${partnerController.todayOrders.value}',
                  Icons.receipt_long,
                  Colors.blue,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[300],
              ),
              Expanded(
                child: _buildStatItem(
                  'Earnings',
                  '₹${partnerController.todayEarnings.value.toStringAsFixed(0)}',
                  Icons.monetization_on,
                  Colors.green,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[300],
              ),
              Expanded(
                child: _buildStatItem(
                  'Rating',
                  '${stats['rating']}',
                  Icons.star,
                  Colors.amber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    if (!partnerController.isOnline.value) {
      return _buildOfflineState();
    }

    if (partnerController.hasActiveOrder.value) {
      return _buildActiveOrderView();
    }

    if (partnerController.currentOrder.value != null) {
      return _buildNewOrderView();
    }

    return _buildWaitingState();
  }

  Widget _buildOfflineState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.power_settings_new,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 20),
          Text(
            'You\'re Offline',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Turn on to start receiving orders',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => partnerController.toggleOnlineStatus(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            icon: Icon(Icons.power_settings_new, color: Colors.white),
            label: Text(
              'GO ONLINE',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(60),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Pulse animation container
                AnimatedContainer(
                  duration: Duration(seconds: 2),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green[200]?.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
                Icon(
                  Icons.delivery_dining,
                  size: 50,
                  color: Colors.green[400],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Waiting for orders...',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'You\'ll be notified when new orders\nare available in your area',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          // Quick actions
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildQuickAction(
                'View History',
                Icons.history,
                () => _showOrderHistory(),
              ),
              SizedBox(width: 20),
              _buildQuickAction(
                'Earnings',
                Icons.account_balance_wallet,
                () => _showEarningsDetails(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.grey[600]),
            SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewOrderView() {
    var order = partnerController.currentOrder.value!;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // New Order Alert Animation
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange[400]!, Colors.deepOrange[500]!],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Animated bell icon
                AnimatedMapMarker(
                  color: Colors.white,
                  icon: Icons.notifications_active,
                  size: 40,
                ),
                SizedBox(height: 10),
                Text(
                  '🔔 NEW ORDER ALERT!',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Order #${order.id.substring(order.id.length - 6)}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Order Details Card
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer info
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      child: Icon(Icons.person, color: Colors.blue[600]),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.customerName,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.phone,
                                  size: 14, color: Colors.grey[600]),
                              SizedBox(width: 4),
                              Text(
                                '+91-98765-43210',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 15),

                // Location
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, color: Colors.red[400], size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery Address',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            order.customerAddress,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 15),

                // Order summary
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.receipt,
                              color: Colors.grey[600], size: 20),
                          SizedBox(width: 10),
                          Text(
                            '${order.items.length} items',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          Spacer(),
                          Text(
                            '₹${order.totalAmount.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[600],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              color: Colors.grey[600], size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Distance: ~0.8 km • Est. 5 mins',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Earn ₹${(order.totalAmount * 0.1).toStringAsFixed(0)}',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 25),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => partnerController.declineOrder(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    side: BorderSide(color: Colors.grey[300]!),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'DECLINE',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () =>
                      partnerController.acceptOrder('demo_partner'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'ACCEPT ORDER',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 15),

          // Timeout indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer, size: 16, color: Colors.red[600]),
                SizedBox(width: 8),
                Text(
                  'Order expires in 45 seconds',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.red[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveOrderView() {
    var order = partnerController.currentOrder.value!;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // Active Order Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green[400]!, Colors.green[600]!],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.delivery_dining,
                  color: Colors.white,
                  size: 40,
                ),
                SizedBox(height: 10),
                Text(
                  '🚚 ACTIVE DELIVERY',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Order #${order.id.substring(order.id.length - 6)}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Map Tracking
          OrderTrackingMap(
            customerLat: order.customerLatitude,
            customerLng: order.customerLongitude,
            partnerLat: 28.6100,
            partnerLng: 77.2050,
          ),

          SizedBox(height: 15),

          // Delivery Progress
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Progress',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                _buildProgressStep('Order Confirmed', true, false),
                _buildProgressStep('On the way to Restaurant', true, false),
                _buildProgressStep('Picked up from Restaurant', true, true),
                _buildProgressStep('On the way to Customer', false, false),
                _buildProgressStep('Delivered', false, false),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Customer Contact Card
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: Icon(Icons.person, color: Colors.blue[600]),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.customerName,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        order.customerAddress,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.snackbar(
                      'Calling Customer',
                      'Connecting to ${order.customerName}...',
                      backgroundColor: Colors.green[600],
                      colorText: Colors.white,
                      duration: Duration(seconds: 2),
                    );
                  },
                  icon: Icon(Icons.call, color: Colors.green[600]),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(12),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    Get.snackbar(
                      'Opening Maps',
                      'Navigating to customer location...',
                      backgroundColor: Colors.blue[600],
                      colorText: Colors.white,
                      duration: Duration(seconds: 2),
                    );
                  },
                  icon: Icon(Icons.navigation, color: Colors.blue[600]),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Complete Delivery Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _completeDeliveryConfirmation(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[600],
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    'MARK AS DELIVERED',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 10),

          // Emergency button
          TextButton.icon(
            onPressed: () => _showEmergencyOptions(),
            icon: Icon(Icons.warning, color: Colors.red[600]),
            label: Text(
              'Report Issue',
              style: GoogleFonts.poppins(
                color: Colors.red[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStep(String title, bool completed, bool current) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: completed
                  ? Colors.green[600]
                  : current
                      ? Colors.orange[600]
                      : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Icon(
              completed
                  ? Icons.check
                  : current
                      ? Icons.radio_button_checked
                      : Icons.circle,
              size: 16,
              color: completed || current ? Colors.white : Colors.grey[600],
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: current ? FontWeight.w600 : FontWeight.normal,
                color:
                    completed || current ? Colors.grey[800] : Colors.grey[600],
              ),
            ),
          ),
          if (current)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Current',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.orange[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _completeDeliveryConfirmation() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Complete Delivery',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 60,
              color: Colors.green[600],
            ),
            SizedBox(height: 15),
            Text(
              'Are you sure you want to mark this order as delivered?',
              style: GoogleFonts.poppins(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              partnerController.completeOrder();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
            ),
            child: Text('Mark as Delivered'),
          ),
        ],
      ),
    );
  }

  void _showTrackingDetails(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    'Live Tracking',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: OrderTrackingMap(
                customerLat:
                    partnerController.currentOrder.value!.customerLatitude,
                customerLng:
                    partnerController.currentOrder.value!.customerLongitude,
                partnerLat: 28.6100,
                partnerLng: 77.2050,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderHistory() {
    Get.snackbar(
      'Order History',
      'Feature coming soon! View your delivery history.',
      backgroundColor: Colors.blue[600],
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

  void _showEarningsDetails() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    'Earnings Details',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Today's earnings
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green[400]!, Colors.green[600]!],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.account_balance_wallet,
                              color: Colors.white, size: 30),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Today\'s Earnings',
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '₹${partnerController.todayEarnings.value.toStringAsFixed(0)}',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // Weekly earnings breakdown
                    ...partnerController
                        .getWeeklyStats()
                        .map(
                          (dayStat) => Container(
                            margin: EdgeInsets.only(bottom: 8),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  dayStat['day'],
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Text(
                                    '${dayStat['orders']} orders',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                ),
                                Text(
                                  '₹${dayStat['earnings'].toStringAsFixed(0)}',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmergencyOptions() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Report Issue',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.location_off, color: Colors.orange),
              title: Text('Unable to find customer'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Issue Reported',
                  'Support team will contact you shortly',
                  backgroundColor: Colors.orange[600],
                  colorText: Colors.white,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel, color: Colors.red),
              title: Text('Order cancelled by customer'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Order Cancelled',
                  'Order has been cancelled and reported',
                  backgroundColor: Colors.red[600],
                  colorText: Colors.white,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.help, color: Colors.blue),
              title: Text('Other issue'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Support Contacted',
                  'Support team will call you within 2 minutes',
                  backgroundColor: Colors.blue[600],
                  colorText: Colors.white,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
