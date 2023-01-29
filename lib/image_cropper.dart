import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:screenshot/screenshot.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.imageFile});
  final File imageFile;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Offset> pointsList = [];
  bool croppedImage = false;
  final ScreenshotController _screenshotController = ScreenshotController();
  late ui.Image image;
  bool isImageLoaded = false;
  int rotation = 0;

  //TODO: To load image
  Future<ui.Image> loadImage(Uint8List img) {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image image) {
      setState(() {
        isImageLoaded = true;
      });
      return completer.complete(image);
    });
    return completer.future;
  }

  Future<void> initFunc() async {
    image = await loadImage(File(widget.imageFile.path).readAsBytesSync());
  }

  Widget _buildImage() {}
  @override
  void initState() {
    // TODO: implement initState
    initFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
