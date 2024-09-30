import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * 0.8,
      height: screenHeight * 0.8,
      child: Column(
        children: [
          SizedBox(
            width: screenWidth * 0.2,
            child: Text("标签筛选："),
          ),
          SizedBox(
            width: screenWidth * 0.8,
            child: Container(),
          )
        ],
      ),
    );
  }
}
