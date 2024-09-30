import 'package:flutter/material.dart';
import 'ui/page/StartPage.dart';
import 'ui/page/StudyPage.dart';
import 'ui/page/MainPage.dart';
import 'ui/page/DataAddArea.dart';
import 'ui/test/question_form.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,

        // 定义全局字体样式
        textTheme: const TextTheme(
            displayLarge: TextStyle(
              color: Color.fromARGB(255, 243, 243, 243),
              fontSize: 40,
            ),
            labelMedium: TextStyle(
                color: Color.fromARGB(255, 243, 243, 243), fontSize: 16)),
      ),
      home: StartPage(),
    );
  }
}
