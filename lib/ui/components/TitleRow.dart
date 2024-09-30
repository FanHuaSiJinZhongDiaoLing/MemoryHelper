import 'package:flutter/material.dart';
import 'package:memory_helper001/ui/page/DataManageArea.dart';

class Titlerow extends StatelessWidget {
  String titleText;
  double height;

  Titlerow({required this.titleText, this.height = 0.15});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // TODO: implement build
    return SizedBox(
      height: screenHeight * height,
      width: screenHeight,
      child: Center(
        child: Text(
          titleText,
          style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
