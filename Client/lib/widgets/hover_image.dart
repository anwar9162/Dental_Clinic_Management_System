import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'full_screen_image.dart'; // Ensure you have the FullScreenImage widget imported

class HoverImage extends StatefulWidget {
  final String imagePath; // This should be the URL of the image
  final DateTime dateCaptured;

  HoverImage({required this.imagePath, required this.dateCaptured});

  @override
  _HoverImageState createState() => _HoverImageState();
}

class _HoverImageState extends State<HoverImage> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovering = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  FullScreenImage(imagePath: widget.imagePath),
            ),
          );
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: _isHovering ? 180 : 160,
              height: _isHovering ? 180 : 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                image: DecorationImage(
                  image: NetworkImage(widget.imagePath),
                  fit: BoxFit.cover,
                ),
                boxShadow: _isHovering
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
              ),
            ),
            if (_isHovering)
              Positioned(
                top: -40,
                left: -40,
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      image: DecorationImage(
                        image: NetworkImage(widget.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  DateFormat('yyyy-MMMM-dd').format(widget.dateCaptured),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
