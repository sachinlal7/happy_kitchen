import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'animated_map_marker.dart';

class OrderTrackingMap extends StatelessWidget {
  final double customerLat;
  final double customerLng;
  final double partnerLat;
  final double partnerLng;

  const OrderTrackingMap({
    Key? key,
    required this.customerLat,
    required this.customerLng,
    required this.partnerLat,
    required this.partnerLng,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Mock map background
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue[100]!,
                    Colors.green[100]!,
                  ],
                ),
              ),
              child: CustomPaint(
                painter: MapPainter(),
              ),
            ),
          ),

          // Customer marker (top-right)
          Positioned(
            top: 30,
            right: 40,
            child: Column(
              children: [
                AnimatedMapMarker(
                  color: Colors.red[600]!,
                  icon: Icons.home,
                  size: 35,
                ),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    'Customer',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Delivery partner marker (bottom-left)
          Positioned(
            bottom: 40,
            left: 50,
            child: Column(
              children: [
                PulsingMarker(
                  color: Colors.green[600]!,
                  size: 35,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.green[600],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.4),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.delivery_dining,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    'Partner',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Distance and time info (top-left)
          Positioned(
            top: 15,
            left: 15,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.route, size: 16, color: Colors.blue[600]),
                  SizedBox(width: 5),
                  Text(
                    '0.8 km • 5 min',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ETA info (bottom-right)
          Positioned(
            bottom: 15,
            right: 15,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green[600],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.schedule, size: 14, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'ETA: 5 min',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
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
    );
  }
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw grid lines to simulate streets
    final path = Path();

    // Horizontal lines (streets)
    for (int i = 1; i < 5; i++) {
      double y = size.height / 5 * i;
      path.moveTo(0, y);
      path.lineTo(size.width, y);
    }

    // Vertical lines (avenues)
    for (int i = 1; i < 6; i++) {
      double x = size.width / 6 * i;
      path.moveTo(x, 0);
      path.lineTo(x, size.height);
    }

    canvas.drawPath(path, paint);

    // Draw route between partner and customer
    final routePaint = Paint()
      ..color = Colors.blue[600]!
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final routePath = Path();
    routePath.moveTo(50, size.height - 40); // Partner position (bottom-left)

    // Create a curved path to customer
    routePath.quadraticBezierTo(
      size.width / 2, size.height / 3, // Control point
      size.width - 40, 30, // Customer position (top-right)
    );

    canvas.drawPath(routePath, routePaint);

    // Add some landmark indicators
    _drawLandmarks(canvas, size);
  }

  void _drawLandmarks(Canvas canvas, Size size) {
    final landmarkPaint = Paint()
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.fill;

    // Draw some building/landmark rectangles
    final landmarks = [
      Rect.fromLTWH(size.width * 0.2, size.height * 0.3, 15, 10),
      Rect.fromLTWH(size.width * 0.7, size.height * 0.6, 12, 8),
      Rect.fromLTWH(size.width * 0.4, size.height * 0.8, 18, 12),
      Rect.fromLTWH(size.width * 0.8, size.height * 0.2, 10, 15),
    ];

    for (final landmark in landmarks) {
      canvas.drawRect(landmark, landmarkPaint);
    }

    // Draw some park areas (circles)
    final parkPaint = Paint()
      ..color = Colors.green[200]!
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.7),
      8,
      parkPaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.6, size.height * 0.4),
      6,
      parkPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Enhanced tracking map with real-time updates
class LiveTrackingMap extends StatefulWidget {
  final double customerLat;
  final double customerLng;
  final double partnerLat;
  final double partnerLng;
  final VoidCallback? onMapTap;

  const LiveTrackingMap({
    Key? key,
    required this.customerLat,
    required this.customerLng,
    required this.partnerLat,
    required this.partnerLng,
    this.onMapTap,
  }) : super(key: key);

  @override
  _LiveTrackingMapState createState() => _LiveTrackingMapState();
}

class _LiveTrackingMapState extends State<LiveTrackingMap>
    with TickerProviderStateMixin {
  late AnimationController _partnerMoveController;
  late Animation<Offset> _partnerPosition;

  @override
  void initState() {
    super.initState();

    _partnerMoveController = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    );

    _partnerPosition = Tween<Offset>(
      begin: Offset(0.2, 0.8), // Starting position
      end: Offset(0.8, 0.2), // Ending position (near customer)
    ).animate(CurvedAnimation(
      parent: _partnerMoveController,
      curve: Curves.easeInOut,
    ));

    // Start the animation
    _partnerMoveController.forward();
  }

  @override
  void dispose() {
    _partnerMoveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onMapTap,
      child: Container(
        height: 250,
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Map background
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue[100]!,
                      Colors.green[100]!,
                      Colors.orange[50]!,
                    ],
                  ),
                ),
                child: CustomPaint(
                  painter: EnhancedMapPainter(),
                ),
              ),
            ),

            // Customer marker (fixed position)
            Positioned(
              top: 40,
              right: 50,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red[600],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(Icons.home, color: Colors.white, size: 20),
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 4)
                      ],
                    ),
                    child: Text(
                      'Destination',
                      style: GoogleFonts.poppins(
                          fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            // Animated delivery partner marker
            AnimatedBuilder(
              animation: _partnerPosition,
              builder: (context, child) {
                return Positioned(
                  left: _partnerPosition.value.dx *
                      (MediaQuery.of(context).size.width - 100),
                  top: _partnerPosition.value.dy * 200,
                  child: Column(
                    children: [
                      PulsingMarker(
                        color: Colors.green[600]!,
                        size: 40,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.green[600],
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.4),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.delivery_dining,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 4)
                          ],
                        ),
                        child: Text(
                          'Delivery Partner',
                          style: GoogleFonts.poppins(
                              fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Info overlays
            Positioned(
              top: 15,
              left: 15,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.navigation, size: 16, color: Colors.blue[600]),
                    SizedBox(width: 5),
                    Text(
                      'Live Tracking',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Speed and ETA info
            Positioned(
              bottom: 15,
              right: 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange[600],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      '25 km/h',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green[600],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      'ETA: 3 min',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tap to expand hint
            if (widget.onMapTap != null)
              Positioned(
                bottom: 15,
                left: 15,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.fullscreen, size: 12, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'Tap to expand',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class EnhancedMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw a more detailed street grid
    final streetPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..strokeWidth = 2;

    final mainStreetPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 3;

    // Main streets (horizontal)
    for (int i = 1; i < 4; i++) {
      double y = size.height / 4 * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y),
          i == 2 ? mainStreetPaint : streetPaint);
    }

    // Main streets (vertical)
    for (int i = 1; i < 4; i++) {
      double x = size.width / 4 * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height),
          i == 2 ? mainStreetPaint : streetPaint);
    }

    // Add some decorative elements
    _drawBuildings(canvas, size);
    _drawParks(canvas, size);
  }

  void _drawBuildings(Canvas canvas, Size size) {
    final buildingPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final buildings = [
      Rect.fromLTWH(size.width * 0.1, size.height * 0.2, 20, 25),
      Rect.fromLTWH(size.width * 0.8, size.height * 0.7, 25, 20),
      Rect.fromLTWH(size.width * 0.3, size.height * 0.8, 30, 15),
      Rect.fromLTWH(size.width * 0.7, size.height * 0.1, 15, 30),
      Rect.fromLTWH(size.width * 0.5, size.height * 0.6, 22, 18),
    ];

    for (final building in buildings) {
      canvas.drawRect(building, buildingPaint);
    }
  }

  void _drawParks(Canvas canvas, Size size) {
    final parkPaint = Paint()
      ..color = Colors.green.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(size.width * 0.2, size.height * 0.7), 12, parkPaint);
    canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.3), 15, parkPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
