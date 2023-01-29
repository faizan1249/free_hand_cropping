import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MyImagePainter extends CustomPainter {
  late ui.Image image;
  int height;
  final bool crop;
  final BuildContext context;
  final List<Offset> pointList;

  MyImagePainter(
      {required this.image,
      required this.context,
      required this.height,
      required this.crop,
      required this.pointList});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    canvas.drawImage(image, const Offset(0, 0), Paint());
    // _drawDashedLine(canvas, size, paint);

    if (pointList.isNotEmpty && !crop) {
      try {
        print("POINTS LENGTH :: ${pointList.length}");

        canvas.drawPoints(
            ui.PointMode.polygon,
            pointList,
            Paint()
              //..strokeWidth = 20 * (image.height / height)
              ..strokeWidth = 36.0
              ..color = Colors.red
              ..strokeCap = StrokeCap.round);

        // canvas.drawLine(
        //     pointList[0],
        //     pointList[pointList.length - 1],
        //     Paint()
        //       ..strokeWidth = 3.0
        //       ..color = Colors.white
        //       ..strokeCap = StrokeCap.round);
      } catch (err) {
        // ignore: prefer_interpolation_to_compose_strings
        print("Error: " + err.toString());
      }
    }
  }

  void _drawDashedLine(Canvas canvas, Size size, Paint paint) {
    // Chage to your preferred size
    const int dashWidth = 4;
    const int dashSpace = 10;
  
    // Start to draw from left size.
    // Of course, you can change it to match your requirement.
    double startX = 0;
    double y = 10;

    // Repeat drawing until we reach the right edge.
    // In our example, size.with = 300 (from the SizedBox)
    while (startX < size.width) {
      // Draw a small line.
      canvas.drawLine(Offset(startX, y), Offset(startX + dashWidth, y), paint);

      // Update the starting X
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    log("INSDE SHOULD PAINT CALLBACK");
    return true;
  }
}
