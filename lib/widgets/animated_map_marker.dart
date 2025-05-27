import 'package:flutter/material.dart';

class AnimatedMapMarker extends StatefulWidget {
  final Color color;
  final double size;
  final IconData icon;

  const AnimatedMapMarker({
    Key? key,
    required this.color,
    this.size = 40,
    this.icon = Icons.location_on,
  }) : super(key: key);

  @override
  _AnimatedMapMarkerState createState() => _AnimatedMapMarkerState();
}

class _AnimatedMapMarkerState extends State<AnimatedMapMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Pulse effect
            Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: widget.size + 20,
                height: widget.size + 20,
                decoration: BoxDecoration(
                  color:
                      widget.color.withOpacity(0.2 * _opacityAnimation.value),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Main marker
            Transform.scale(
              scale: 1.0 + (_scaleAnimation.value - 1.0) * 0.3,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.4),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  widget.icon,
                  color: Colors.white,
                  size: widget.size * 0.6,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Pulsing notification marker
class PulsingMarker extends StatefulWidget {
  final Color color;
  final double size;
  final Widget child;

  const PulsingMarker({
    Key? key,
    required this.color,
    this.size = 50,
    required this.child,
  }) : super(key: key);

  @override
  _PulsingMarkerState createState() => _PulsingMarkerState();
}

class _PulsingMarkerState extends State<PulsingMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer pulse
            Container(
              width: widget.size + (_animation.value * 30),
              height: widget.size + (_animation.value * 30),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color.withOpacity(1.0 - _animation.value),
              ),
            ),
            // Inner pulse
            Container(
              width: widget.size + (_animation.value * 15),
              height: widget.size + (_animation.value * 15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color.withOpacity((1.0 - _animation.value) * 0.5),
              ),
            ),
            // Main content
            widget.child,
          ],
        );
      },
    );
  }
}
