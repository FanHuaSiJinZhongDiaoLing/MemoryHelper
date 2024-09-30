import '../components/UserState.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

double screenWidth = 0;
double screenHeight = 0;
final DB_NameController = TextEditingController(); //inputfeild
final DB_AuthorController = TextEditingController();

Future<List<String>> _fetchData(String dbType) async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
    host: '127.0.0.1',
    port: 3306,
    user: 'root',
    password: '123456',
    db: 'MemoryHelper',
  ));

  await Future.delayed(Duration(milliseconds: 200));

  var result = await conn.query("SELECT DISTINCT db FROM ${dbType};");
  // debugPrint(result.toString());

  // 将结果转换为 List<String>
  List<String> aaaList = result.map((row) => row[0] as String).toList();
  // debugPrint(aaaList.toString());

  conn.close();
  return aaaList;
}

class DatabaseAddArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    debugPrint(screenWidth.toString() + "|" + screenHeight.toString());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.15,
            child: Stack(
              children: [
                Center(
                  child: Text(
                    "新增知识库",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                    top: screenWidth * 0.02,
                    right: screenWidth * 0.02,
                    child: UserState()),
              ],
            ),
          ),
          Center(
            child: Container(
              width: screenWidth * 0.8,
              height: screenHeight * 0.75,
              color: Color.fromARGB(255, 233, 233, 233),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.15,
                    ),
                    SizedBox(
                        width: screenWidth * 0.8 * 0.9,
                        child: Row(
                          children: [
                            Text(
                              "知识库名称：",
                              style: TextStyle(fontSize: screenWidth * 0.028),
                            ),
                            DB_NameInputFeild(),
                          ],
                        )),
                    SizedBox(height: screenHeight * 0.05),
                    SizedBox(
                      width: screenWidth * 0.8 * 0.9,
                      child: Row(
                        children: [
                          Text(
                            "知识库类型：",
                            style: TextStyle(fontSize: screenWidth * 0.028),
                          ),
                          DB_typeDropDown()
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    SizedBox(
                        width: screenWidth * 0.8 * 0.9,
                        child: Row(
                          children: [
                            Text(
                              "知识库作者：",
                              style: TextStyle(fontSize: screenWidth * 0.028),
                            ),
                            DB_AuthorInputFeild(),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.35 * 0.8,
                height: MediaQuery.of(context).size.height * 0.05,
                child: CancelButton(),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1 * 0.8,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.35 * 0.8,
                height: MediaQuery.of(context).size.height * 0.05,
                child: SubmitButton(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DB_typeDropDown extends StatefulWidget {
  @override
  _DB_typeDropDownState createState() => _DB_typeDropDownState();
}

class _DB_typeDropDownState extends State<DB_typeDropDown> {
  String? _selectedValue = '知识点';
  List<String> _dropdownItems = ["知识点", "单词", "错题"];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.55,
      child: DropdownButton<String>(
        value: _selectedValue,
        onChanged: (String? newValue) {
          setState(() {
            _selectedValue = newValue;
          });
        },
        // 自定义下拉选项
        items: _dropdownItems.map<DropdownMenuItem<String>>((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Container(
              width: double.infinity, // 让选项占满下拉框的宽度
              height: 50, // 设置选项高度
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), // 可选，设置圆角
                  border: Border.all(color: Colors.black54, width: 1)),
              alignment: Alignment.center, // 让文本居中
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                item,
                style: TextStyle(
                    fontSize: screenWidth * 0.02, color: Colors.black),
              ),
            ),
          );
        }).toList(),
        dropdownColor: Colors.grey[200], // 整个下拉菜单的背景颜色
        underline: SizedBox(), // 去掉下划线
        icon: Icon(Icons.arrow_drop_down),
        isExpanded: true, // 让下拉框的宽度占满
      ),
    );
  }
}

class DB_AuthorInputFeild extends StatefulWidget {
  @override
  State<DB_AuthorInputFeild> createState() => _DB_AuthorInputFeildState();
}

class _DB_AuthorInputFeildState extends State<DB_AuthorInputFeild> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: screenWidth * 0.55,
        // color: Colors.blue,

        child: TextField(
          style: TextStyle(fontSize: screenWidth * 0.02),
          controller: DB_AuthorController,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 2,
          decoration: InputDecoration(
            labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0), // 圆角半径
            ),
          ),
        ));
  }
}

class DB_NameInputFeild extends StatefulWidget {
  @override
  State<DB_NameInputFeild> createState() => _DB_NameInputFeildState();
}

class _DB_NameInputFeildState extends State<DB_NameInputFeild> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: screenWidth * 0.55,
        // color: Colors.blue,

        child: TextField(
          style: TextStyle(fontSize: screenWidth * 0.02),
          controller: DB_NameController,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 2,
          decoration: InputDecoration(
            labelStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0), // 圆角半径
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
          elevation: 100,
          backgroundColor: Colors.red[100],
          overlayColor: Colors.red[800],
        ),
        onPressed: () {
          debugPrint("取消按钮触发");
        },
        child: Text(
          "取消",
          style: TextStyle(fontSize: 20, color: Colors.red[800]),
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
