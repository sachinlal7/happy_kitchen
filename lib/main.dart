import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kounter_rapid_delivery/controllers/delivery_partner_controller.dart';
import 'package:kounter_rapid_delivery/views/delivery_partner_screen.dart';
import 'package:kounter_rapid_delivery/views/home_screen.dart';
import 'package:kounter_rapid_delivery/views/restaurant_screen.dart';

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
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Image.asset("assets/images/kounter_logo.png")),
              SizedBox(height: 30),
              Text(
                textAlign: TextAlign.center,
                'Kounter \nRapid Delivery',
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
