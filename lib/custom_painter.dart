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
    canvas.drawImage(image, const Offset(0, 0), Paint());
    if (pointList.isNotEmpty && !crop) {
      canvas.drawPoints(
          ui.PointMode.polygon,
          pointList,
          Paint()
            ..strokeWidth = 20 * (image.height / height)
            ..color = Colors.red
            ..strokeCap = StrokeCap.round);

      canvas.drawLine(
          pointList[0],
          pointList[pointList.length - 1],
          Paint()
            ..strokeWidth = 3.0
            ..color = Colors.white
            ..strokeCap = StrokeCap.round);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw true;
  }
}
