import 'package:flutter/material.dart';
import '../components/UserState.dart';

class StudyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
              top: screenWidth * 0.02,
              right: screenWidth * 0.02,
              child: UserState()),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: screenHeight * 0.15),
              width: screenWidth * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QuestionBox(),
                  SizedBox(
                    height: 20,
                  ),
                  AnswerBox(),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 80,
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: CancelButton(),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: ComfirmButton(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class QuestionBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Text(
          "Question框，这里暂时是静态的，未来可以替换为服务器端发过来的JSON包",
          style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 40),
        ),
      ),
    );
  }
}

class AnswerBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
          keyboardType: TextInputType.multiline,
          minLines: 12,
          maxLines: null, // 允许无限行
          decoration: InputDecoration(
            fillColor: Colors.blue[800],
            labelText: "在此输入答案",
            hintStyle: TextStyle(
              fontSize: 40,
            ),
            labelStyle: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(),
          )),
    );
  }
}

class CancelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.red[400],
          elevation: 10,
          backgroundColor: Colors.red[600],
          overlayColor: Colors.red[900],
        ),
        onPressed: () {
          debugPrint("取消按钮触发");
        },
        child: Text(
          "取消",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ));
  }
}

class ComfirmButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shadowColor: Colors.blue[400],
            elevation: 10,
            backgroundColor: Colors.blue[600],
            overlayColor: Colors.blue[900]),
        onPressed: () {
          debugPrint("确定按钮触发");
        },
        child: Text(
          "确定",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ));
  }
}
