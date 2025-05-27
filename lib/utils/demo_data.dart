import 'dart:math';

import 'package:happy_kitchen_delivery/models/delivery_partner_model.dart';
import 'package:happy_kitchen_delivery/models/order_model.dart';

class DemoData {
  static List<String> customerNames = [
    'Arjun Patel',
    'Priya Singh',
    'Rahul Kumar',
    'Anjali Sharma',
    'Vikram Yadav',
    'Neha Gupta',
    'Rohit Verma',
    'Kavya Reddy',
    'Arun Nair',
    'Divya Menon',
    'Karthik Iyer',
    'Shreya Joshi',
    'Manish Agarwal',
    'Pooja Bajaj',
    'Suresh Chand',
    'Ritu Saxena'
  ];

  static List<String> addresses = [
    'Connaught Place, Central Delhi',
    'Khan Market, New Delhi',
    'Karol Bagh, West Delhi',
    'Lajpat Nagar, South Delhi',
    'Chandni Chowk, Old Delhi',
    'Saket, South Delhi',
    'Rohini, North Delhi',
    'Dwarka, South West Delhi',
    'Vasant Kunj, South Delhi',
    'Janakpuri, West Delhi',
    'Greater Kailash, South Delhi',
    'Nehru Place, New Delhi',
    'Rajouri Garden, West Delhi',
    'Pitampura, North Delhi',
    'Mayur Vihar, East Delhi'
  ];

  static List<List<OrderItem>> menuItems = [
    // North Indian Combo
    [
      OrderItem(name: 'Butter Chicken', quantity: 2, price: 350),
      OrderItem(name: 'Garlic Naan', quantity: 4, price: 60),
      OrderItem(name: 'Basmati Rice', quantity: 1, price: 180),
      OrderItem(name: 'Raita', quantity: 1, price: 80),
    ],
    // Biryani Special
    [
      OrderItem(name: 'Chicken Biryani', quantity: 1, price: 280),
      OrderItem(name: 'Mutton Biryani', quantity: 1, price: 350),
      OrderItem(name: 'Raita', quantity: 2, price: 80),
      OrderItem(name: 'Gulab Jamun', quantity: 4, price: 120),
    ],
    // Vegetarian Delight
    [
      OrderItem(name: 'Paneer Tikka', quantity: 1, price: 320),
      OrderItem(name: 'Roti', quantity: 3, price: 45),
      OrderItem(name: 'Dal Makhani', quantity: 1, price: 220),
      OrderItem(name: 'Mixed Vegetable', quantity: 1, price: 180),
    ],
    // South Indian Special
    [
      OrderItem(name: 'Masala Dosa', quantity: 2, price: 150),
      OrderItem(name: 'Idli Sambar', quantity: 1, price: 120),
      OrderItem(name: 'Filter Coffee', quantity: 2, price: 60),
      OrderItem(name: 'Coconut Chutney', quantity: 1, price: 40),
    ],
    // Punjabi Combo
    [
      OrderItem(name: 'Chole Bhature', quantity: 1, price: 180),
      OrderItem(name: 'Aloo Paratha', quantity: 2, price: 120),
      OrderItem(name: 'Lassi', quantity: 1, price: 80),
      OrderItem(name: 'Pickle', quantity: 1, price: 30),
    ],
    // Continental Mix
    [
      OrderItem(name: 'Chicken Pizza', quantity: 1, price: 450),
      OrderItem(name: 'Garlic Bread', quantity: 1, price: 120),
      OrderItem(name: 'Cold Drink', quantity: 2, price: 60),
    ],
    // Chinese Combo
    [
      OrderItem(name: 'Chicken Fried Rice', quantity: 1, price: 220),
      OrderItem(name: 'Chilli Chicken', quantity: 1, price: 280),
      OrderItem(name: 'Manchow Soup', quantity: 2, price: 120),
      OrderItem(name: 'Spring Roll', quantity: 4, price: 160),
    ],
    // Snacks Combo
    [
      OrderItem(name: 'Samosa', quantity: 6, price: 90),
      OrderItem(name: 'Pakora', quantity: 1, price: 120),
      OrderItem(name: 'Chai', quantity: 2, price: 40),
      OrderItem(name: 'Chutney', quantity: 2, price: 30),
    ],
  ];

  static List<String> partnerNames = [
    'Raj Kumar',
    'Amit Singh',
    'Priya Sharma',
    'Vikash Yadav',
    'Neha Gupta',
    'Rohit Verma',
    'Anjali Patel',
    'Suresh Kumar',
    'Ravi Teja',
    'Deepika Rao',
    'Manoj Kumar',
    'Sunita Devi',
    'Ajay Sharma',
    'Kavita Singh',
    'Dinesh Yadav',
    'Suman Gupta'
  ];

  static List<String> vehicleTypes = [
    'Bike',
    'Scooter',
    'Bicycle',
    'E-Bike',
    'Car'
  ];

  static Order generateRandomOrder() {
    Random random = Random();

    String orderId = 'HK${DateTime.now().millisecondsSinceEpoch}';
    String customerName = customerNames[random.nextInt(customerNames.length)];
    String address = addresses[random.nextInt(addresses.length)];

    // Generate random coordinates around Delhi
    double baseLat = 28.6139;
    double baseLng = 77.2090;
    double lat = baseLat + (random.nextDouble() - 0.5) * 0.05;
    double lng = baseLng + (random.nextDouble() - 0.5) * 0.05;

    List<OrderItem> items = menuItems[random.nextInt(menuItems.length)];

    return Order(
      id: orderId,
      customerName: customerName,
      customerAddress: address,
      customerLatitude: lat,
      customerLongitude: lng,
      items: items,
      totalAmount:
          items.fold(0, (sum, item) => sum + (item.price * item.quantity)),
      createdAt: DateTime.now(),
    );
  }

  static List<DeliveryPartner> generateMockPartners() {
    Random random = Random();
    List<DeliveryPartner> partners = [];

    for (int i = 0; i < 15; i++) {
      // Generate random coordinates within 3km radius of Delhi center
      double angle = random.nextDouble() * 2 * pi;
      double radius = random.nextDouble() * 0.03; // ~3km in degrees

      double baseLat = 28.6139;
      double baseLng = 77.2090;

      double lat = baseLat + radius * cos(angle);
      double lng = baseLng + radius * sin(angle);

      partners.add(DeliveryPartner(
        id: 'partner_${i + 1}',
        name: partnerNames[i % partnerNames.length],
        latitude: lat,
        longitude: lng,
        isAvailable: i < 8 || random.nextBool(), // Ensure some are available
        rating: 3.0 + random.nextDouble() * 2.0,
        phoneNumber: '+91-${9000000000 + random.nextInt(999999999)}',
        vehicleType: vehicleTypes[random.nextInt(vehicleTypes.length)],
      ));
    }

    return partners;
  }

  static List<Order> generateHistoricalOrders(int count) {
    List<Order> historicalOrders = [];
    Random random = Random();
    DateTime now = DateTime.now();

    for (int i = 0; i < count; i++) {
      DateTime orderTime = now.subtract(Duration(
        days: random.nextInt(30), // Last 30 days
        hours: random.nextInt(24),
        minutes: random.nextInt(60),
      ));

      String orderId = 'HK${orderTime.millisecondsSinceEpoch}';
      String customerName = customerNames[random.nextInt(customerNames.length)];
      String address = addresses[random.nextInt(addresses.length)];

      double baseLat = 28.6139;
      double baseLng = 77.2090;
      double lat = baseLat + (random.nextDouble() - 0.5) * 0.05;
      double lng = baseLng + (random.nextDouble() - 0.5) * 0.05;

      List<OrderItem> items = menuItems[random.nextInt(menuItems.length)];

      List<String> statuses = ['delivered', 'cancelled'];
      String status = statuses[random.nextInt(statuses.length)];

      historicalOrders.add(Order(
        id: orderId,
        customerName: customerName,
        customerAddress: address,
        customerLatitude: lat,
        customerLongitude: lng,
        items: items,
        totalAmount:
            items.fold(0, (sum, item) => sum + (item.price * item.quantity)),
        createdAt: orderTime,
        status: status,
        assignedPartnerId:
            status == 'delivered' ? 'partner_${random.nextInt(15) + 1}' : null,
      ));
    }

    return historicalOrders;
  }

  static Map<String, dynamic> generateRestaurantStats() {
    Random random = Random();
    return {
      'totalOrders': 450 + random.nextInt(100),
      'todayOrders': 25 + random.nextInt(20),
      'monthlyRevenue': 85000 + random.nextDouble() * 25000,
      'avgOrderValue': 280 + random.nextDouble() * 120,
      'avgDeliveryTime': 22 + random.nextInt(18),
      'customerRating': 4.2 + random.nextDouble() * 0.7,
      'activePartners': 8 + random.nextInt(5),
    };
  }

  static List<Map<String, dynamic>> generateChartData() {
    Random random = Random();
    List<Map<String, dynamic>> chartData = [];

    // Generate last 7 days data
    DateTime now = DateTime.now();
    List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    for (int i = 6; i >= 0; i--) {
      DateTime date = now.subtract(Duration(days: i));
      chartData.add({
        'day': days[date.weekday - 1],
        'date': date,
        'orders': 15 + random.nextInt(25),
        'revenue': 3000 + random.nextDouble() * 4000,
        'avgDeliveryTime': 20 + random.nextInt(20),
      });
    }

    return chartData;
  }

  static List<Map<String, dynamic>> generateHourlyData() {
    Random random = Random();
    List<Map<String, dynamic>> hourlyData = [];

    // Peak hours: 12-2 PM and 7-9 PM
    for (int hour = 0; hour < 24; hour++) {
      int baseOrders = 2;

      // Lunch peak
      if (hour >= 11 && hour <= 14) {
        baseOrders = 8 + random.nextInt(6);
      }
      // Dinner peak
      else if (hour >= 18 && hour <= 21) {
        baseOrders = 10 + random.nextInt(8);
      }
      // Evening snacks
      else if (hour >= 15 && hour <= 17) {
        baseOrders = 4 + random.nextInt(4);
      }
      // Late night
      else if (hour >= 22 || hour <= 2) {
        baseOrders = 2 + random.nextInt(3);
      }
      // Morning
      else if (hour >= 8 && hour <= 10) {
        baseOrders = 3 + random.nextInt(3);
      }

      hourlyData.add({
        'hour': hour,
        'orders': baseOrders + random.nextInt(3),
        'timeLabel': '${hour.toString().padLeft(2, '0')}:00',
      });
    }

    return hourlyData;
  }

  static List<Map<String, dynamic>> getPopularItems() {
    return [
      {'name': 'Butter Chicken', 'orders': 45, 'revenue': 15750},
      {'name': 'Chicken Biryani', 'orders': 38, 'revenue': 10640},
      {'name': 'Paneer Tikka', 'orders': 32, 'revenue': 10240},
      {'name': 'Masala Dosa', 'orders': 28, 'revenue': 4200},
      {'name': 'Chole Bhature', 'orders': 25, 'revenue': 4500},
      {'name': 'Chicken Pizza', 'orders': 22, 'revenue': 9900},
      {'name': 'Garlic Naan', 'orders': 65, 'revenue': 3900},
      {'name': 'Fried Rice', 'orders': 20, 'revenue': 4400},
    ];
  }

  static Map<String, List<double>> getDeliveryHeatmapData() {
    // Generate heatmap data for delivery zones
    Random random = Random();
    Map<String, List<double>> heatmapData = {};

    List<String> zones = [
      'Central Delhi',
      'South Delhi',
      'North Delhi',
      'East Delhi',
      'West Delhi',
      'New Delhi',
      'South West Delhi'
    ];

    for (String zone in zones) {
      heatmapData[zone] = [
        28.6139 + (random.nextDouble() - 0.5) * 0.1, // lat
        77.2090 + (random.nextDouble() - 0.5) * 0.1, // lng
        random.nextDouble() * 100, // intensity
      ];
    }

    return heatmapData;
  }

  static List<Map<String, dynamic>> generateNotifications() {
    DateTime now = DateTime.now();
    return [
      {
        'title': 'New Order Received',
        'message': 'Order #HK123456 from Arjun Patel',
        'time': now.subtract(Duration(minutes: 5)),
        'type': 'order',
        'isRead': false,
      },
      {
        'title': 'Partner Assigned',
        'message': 'Raj Kumar accepted order #HK123455',
        'time': now.subtract(Duration(minutes: 12)),
        'type': 'assignment',
        'isRead': false,
      },
      {
        'title': 'Order Delivered',
        'message': 'Order #HK123454 delivered successfully',
        'time': now.subtract(Duration(minutes: 25)),
        'type': 'delivery',
        'isRead': true,
      },
      {
        'title': 'New Partner Joined',
        'message': 'Neha Gupta is now available for deliveries',
        'time': now.subtract(Duration(hours: 1)),
        'type': 'partner',
        'isRead': true,
      },
      {
        'title': 'Peak Hour Alert',
        'message': 'High demand expected. Consider increasing prep time.',
        'time': now.subtract(Duration(hours: 2)),
        'type': 'alert',
        'isRead': true,
      },
    ];
  }
}
