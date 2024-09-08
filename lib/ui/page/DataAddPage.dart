import 'package:flutter/material.dart';
import '../components/UserState.dart';

double screenWidth = 0;
double screenHeight = 0;

class Dataaddpage extends StatefulWidget {
  const Dataaddpage.DataAddPage({super.key});

  @override
  State<Dataaddpage> createState() => _DataaddpageState();
}

class _DataaddpageState extends State<Dataaddpage> {
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerQuestion = TextEditingController();
  final TextEditingController _controllerContent = TextEditingController();
  final TextEditingController _controllerTips = TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    debugPrint(screenWidth.toString() + "|" + screenHeight.toString());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.15,
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      "新增内容",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                      top: screenWidth * 0.02,
                      right: screenWidth * 0.02,
                      child: Menu()),
                ],
              ),
            ),
            Center(
              child: Container(
                width: screenWidth * 0.8,
                color: Color.fromARGB(255, 233, 233, 233),
                child: Column(
                  children: [
                    DatabaseDropdown(),
                    TitleInputFeild(),
                    QuestionInputFeild(),
                    ContentInputFeild(),
                    Container(
                      margin: EdgeInsets.all(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width:
                                MediaQuery.of(context).size.width * 0.35 * 0.8,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: CancelButton(),
                          ),
                          SizedBox(
                            width:
                                MediaQuery.of(context).size.width * 0.1 * 0.8,
                          ),
                          SizedBox(
                            width:
                                MediaQuery.of(context).size.width * 0.35 * 0.8,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: SubmitButton(),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DatabaseDropdown extends StatefulWidget {
  @override
  State<DatabaseDropdown> createState() => _DatabaseDropdownState();
}

class _DatabaseDropdownState extends State<DatabaseDropdown> {
  String? _selectedValue;
  List<String> _dropdownItems = ["暂时写成静态，后面从JSON里读json", "第二个选项", "第三个选项"];
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedValue,
      hint: Text('选择要导入的数据库'),
      items: _dropdownItems.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedValue = newValue; // 更新选中的值
        });
      },
    );
  }
}

class TitleInputFeild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

class QuestionInputFeild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: screenWidth * 0.7,
        // color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: TextField(
            keyboardType: TextInputType.multiline,
            minLines: 3,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: "知识点简述/问题",
              labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0), // 圆角半径
              ),
            ),
          ),
        ));
  }
}

class ContentInputFeild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: screenWidth * 0.7,
        // color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: TextField(
            keyboardType: TextInputType.multiline,
            minLines: 8,
            maxLines: 8,
            decoration: InputDecoration(
              labelText: "知识点内容",
              labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0), // 圆角半径
              ),
            ),
          ),
        ));
  }
}

class TipsInputFeild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: screenWidth * 0.7,
        margin: EdgeInsets.only(top: 20),
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: TextField(
            keyboardType: TextInputType.multiline,
            minLines: 8,
            maxLines: 15,
            decoration: InputDecoration(
              labelText: "content",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0), // 圆角半径
              ),
            ),
          ),
        ));
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
          overlayColor: Colors.red[200],
        ),
        onPressed: () {
          debugPrint("取消按钮触发");
        },
        child: Text(
          "取消",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ));
  }
}

class SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shadowColor: Colors.blue[400],
            elevation: 10,
            backgroundColor: Colors.blue[600],
            overlayColor: Colors.blue[900]),
        onPressed: () {
          debugPrint("提交按钮触发");
        },
        child: Text(
          "提交",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ));
  }
}
