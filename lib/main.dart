import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:happy_kitchen_delivery/controllers/delivery_partner_controller.dart';
import 'package:happy_kitchen_delivery/views/delivery_partner_screen.dart';
import 'package:happy_kitchen_delivery/views/home_screen.dart';
import 'package:happy_kitchen_delivery/views/restaurant_screen.dart';

void main() {
  // Initialize controllers
  Get.put(DeliveryPartnerController());

  runApp(HappyKitchenApp());
}

class HappyKitchenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Happy Kitchen Delivery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: GoogleFonts.poppins().fontFamily,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: SplashScreen(),
      getPages: [
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/delivery', page: () => DeliveryPartnerScreen()),
        GetPage(name: '/restaurant', page: () => RestaurantScreen()),
      ],
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Get.offAll(() => HomeScreen());
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orange[400]!, Colors.deepOrange[600]!],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.restaurant_menu,
                  size: 60,
                  color: Colors.orange[600],
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Happy Kitchen',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Smart Delivery System',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
