import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:free_hand_cropping/app.dart';
import 'package:free_hand_cropping/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelector extends StatefulWidget {
  const ImageSelector({super.key});

  @override
  State<ImageSelector> createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  PickedFile? imageFile;
  bool isImageResized = false, isFirst = true;
  Uint8List? croppedImage;

  //TODO: Function to Load image
  Future<PickedFile> loadImage(bool gallery) async {
    Navigator.of(context).pop();
    final Completer<PickedFile> completer = Completer();
    if (gallery) {
      ImagePicker().pickImage(source: ImageSource.gallery).then((pickedFile) {
        setState(() {
          isImageResized = true;
          croppedImage = null;
        });
        return completer.complete(PickedFile(pickedFile!.path));
      });
    } else {
      ImagePicker().pickImage(source: ImageSource.camera).then((pickedFile) {
        setState(() {
          isImageResized = true;
          croppedImage = null;
        });
        return completer.complete(PickedFile(pickedFile!.path));
      });
    }
    return completer.future;
  }

  _resizeImage(bool gallery) async {
    imageFile = await loadImage(gallery);
  }

  Future<void> _alertChoiceDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select Image"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                

                  GestureDetector(
                    child: const Text("Gallery"),
                    onTap: () {
                      setState(() {
                        isFirst = false;
                        imageFile = null;
                        isImageResized = false;
                        _resizeImage(true);
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    child: const Text("Camera"),
                    onTap: () {
                      setState(() {
                        isFirst = false;
                        imageFile = null;
                        isImageResized = false;
                        _resizeImage(false);
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _imageDecider() {
    if (isFirst || imageFile == null) return Container();
    return _images();
  }

  _images() {
    if (!isImageResized || imageFile == null) {
      return const Center(
        child: Text("Loading...."),
      );
    }
    if (croppedImage == null) return Image.file(File(imageFile!.path));
    return Image.memory(croppedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parent Fragment"),
        actions: [
          IconButton(
              onPressed: () {
                _alertChoiceDialog(context);
              },
              icon: const Icon(Icons.edit)),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 200,
                child: _imageDecider(),
              ),
              ElevatedButton(
                  onPressed: () async {
                    print("IMAGE FILE:: $imageFile");

                    if (imageFile != null) {
                      final result = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MyHomePage(
                          imageFile: File(imageFile!.path),
                        );
                      }));

                      setState(() {
                        print("RESULT:: $result");
                        croppedImage = result;
                      });
                    }
                  },
                  child: const Text("Click to Edit"))
            ],
          ),
        ),
      ),
    );
  }
}
