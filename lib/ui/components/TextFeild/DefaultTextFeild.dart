import 'package:flutter/material.dart';
import 'package:memory_helper001/ui/page/DataAddPage.dart';

class TitleInputFeild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Container(
        width: screenWidth * 0.7,
        // color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: TextField(
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 1,
            decoration: InputDecoration(
              labelText: "标题",
              labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0), // 圆角半径
              ),
            ),
          ),
        ));
  }
}
