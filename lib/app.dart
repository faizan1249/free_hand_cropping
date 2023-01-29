import 'package:flutter/material.dart';
import 'package:free_hand_cropping/image_selector.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ImageSelector(),
    );
  }
}
