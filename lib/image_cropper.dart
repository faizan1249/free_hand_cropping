import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:free_hand_cropping/custom_clipper.dart';
import 'package:free_hand_cropping/custom_painter.dart';
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

  Widget _buildImage() {
    if (isImageLoaded) {
      return Center(
        child: RotatedBox(
          quarterTurns: rotation,
          child: FittedBox(
            child: SizedBox(
                height: image.height.toDouble(),
                width: image.width.toDouble(),
                child: croppedImage
                    ? Screenshot(
                        controller: _screenshotController,
                        child: ClipPath(
                          clipper: MyClipper(pointsList: pointsList),
                          child: Image.file(widget.imageFile),
                        ))
                    : CustomPaint(
                        painter: MyImagePainter(
                            image: image,
                            context: context,
                            height: 400,
                            // height: MediaQuery.of(context).size.width.toInt(),
                            crop: croppedImage,
                            pointList: pointsList),
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            Offset click = Offset(details.localPosition.dx,
                                details.localPosition.dy);
                            setState(() {
                              if (click.dx > 0 &&
                                  click.dy < image.width &&
                                  click.dy > 0 &&
                                  click.dy < image.height) {


                                    
                                pointsList.add(click);
                              }
                            });
                            setState(() {});
                          },
                        ),
                      )),
          ),
        ),
      );
    }
    return const Center(
      child: Text("Loading...."),
    );
  }

  List<Widget> _iconDecider() {
    if (isImageLoaded && !croppedImage) {
      return [
        IconButton(
            onPressed: () {
              setState(() {
                croppedImage = true;
              });
              _screenshotController
                  .capture()
                  .then((Uint8List? imageList) async {
                print("INSIDE CAPTURE SCREENSHOT");
                if (imageList != null) {
                  String path = await FileSaver.instance
                      .saveAs('result image', imageList, 'png', MimeType.PNG);
                  log(path);
                }
              });
            },
            icon: const Icon(Icons.edit)),
      ];
    }
    return [];
  }

  Widget rotate() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              onPressed: () async {
                setState(() {
                  rotation--;
                });
              },
              icon: const Icon(Icons.rotate_left)),
          IconButton(
              onPressed: () async {
                setState(() {
                  rotation++;
                });
              },
              icon: const Icon(Icons.rotate_right)),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    initFunc();
  }

  @override
  Widget build(BuildContext context) {
    var appBar2 = AppBar(
      title: const Text("Doc Scanner"),
      actions: _iconDecider(),
    );
    return Scaffold(
      // key: GlobalKey(),
      appBar: appBar2,
      body: _buildImage(),
      bottomNavigationBar: rotate(),
    );
  }
}
