import 'package:flutter/material.dart';

class AlmondsFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;
    return Container(
      color: Color(0xFF232323),
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top Logo and Links Row (responsive)
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _LogoTextRow(),
                  _LinksRow(),
                ],
              );
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _FooterLink('Copyright $year Almonds AI.', () {
                  /* Implement navigation */
                }),
                SizedBox(
                  width: 50,
                )
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Made with ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
                Image.asset(
                  "assets/images/heart.png",
                  height: 26,
                ),
                Text(
                  ' by',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 12,
                      fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
                Image.asset(
                  "assets/images/almond_logo.png",
                  scale: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Logo & Brand Section
class _LogoTextRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Replace this with your logo if you have an asset, else use an Icon
          Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Image.asset("assets/images/kounter_logo.png")),

          SizedBox(width: 8),
          Text(
            "kounter",
            style: TextStyle(color: Colors.white, fontSize: 14),
          )
        ],
      ),
    );
  }
}

// Terms and Privacy Links
class _LinksRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        children: [
          _FooterLink('Term & Conditions', () {/* Implement navigation */}),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('|',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w300)),
          ),
          _FooterLink('Privacy Policy', () {/* Implement navigation */}),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _FooterLink(this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.90),
          fontSize: 12,
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
