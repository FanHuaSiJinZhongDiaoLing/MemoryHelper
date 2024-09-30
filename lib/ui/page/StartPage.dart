import 'package:flutter/material.dart';
import 'package:memory_helper001/ui/page/DataAddArea.dart';
import 'package:mysql1/mysql1.dart';

import '../components/UserState.dart';
import 'StudyPage.dart';

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

class StartPage extends StatelessWidget {
  double screenWidth = 0;
  double screenHeight = 0;
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.white,
      child: Center(
          child: Stack(
        children: [
          Positioned(
              top: screenHeight * 0.02,
              right: screenWidth * 0.02,
              child: UserState()),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StartRow(
                buttonText: "知识点",
                dbType: "questions",
              ),
              SizedBox(height: screenHeight * 0.03), // 用于分隔两个组件
              StartRow(
                buttonText: "单词",
                dbType: "questions",
              ),
              SizedBox(height: screenHeight * 0.03), // 用于分隔两个组件
              StartRow(
                buttonText: "错题",
                dbType: "questions",
              ),
              SizedBox(height: screenHeight * 0.03), // 用于分隔两个组件
              tips(),
              // Menu()
            ],
          ),
        ],
      )),
    );
  }
}

class StartRow extends StatefulWidget {
  final bool isVisible;
  String buttonText;
  String dbType;

  StartRow(
      {this.isVisible = true, required this.buttonText, required this.dbType});

  @override
  State<StartRow> createState() => _StartRowState();
}

class _StartRowState extends State<StartRow> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final Color primaryColor = Theme.of(context).primaryColor;

    return Center(
      child: SizedBox(
        width: screenWidth * 0.7,
        height: screenHeight * 0.1,
        child: Stack(
          children: [
            Container(
              width: screenWidth * 0.5,
              height: screenHeight * 0.1,
              child: ElevatedButton(
                onPressed: () {
                  debugPrint("已点击");
                  debugPrint(screenHeight.toString());
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => StudyPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                ),
                child: Text(
                  widget.buttonText,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Container(
                color: Colors.blue[200],
                width: screenWidth * 0.2,
                height: screenHeight * 0.1,
                child: Material(
                  child: FutureBuilder<List<String>>(
                    future: _fetchData("questions"), // 调用异步函数
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // 显示加载指示器
                      } else if (snapshot.hasError) {
                        return Text('加载失败'); // 错误处理
                      } else if (snapshot.hasData) {
                        // 成功返回数据，使用返回的列表
                        return MyDropdown(
                          db: "questions",
                        );
                      } else {
                        return Text('没有数据');
                      }
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StartRow1 extends StatefulWidget {
  final bool isVisible;
  String buttonText;
  String dbType;

  StartRow1(
      {this.isVisible = true, required this.buttonText, required this.dbType});

  @override
  State<StartRow> createState() => _StartRowState1();
}

class _StartRowState1 extends State<StartRow> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final Color primaryColor = Theme.of(context).primaryColor;

    return Center(
      child: SizedBox(
        width: screenWidth * 0.7,
        height: screenHeight * 0.1,
        child: Stack(
          children: [
            Container(
              width: screenWidth * 0.5,
              height: screenHeight * 0.1,
              child: ElevatedButton(
                onPressed: () {
                  debugPrint("已点击");
                  debugPrint(screenHeight.toString());
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => StudyPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                ),
                child: Text(
                  widget.buttonText,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Container(
                color: Colors.blue[200],
                width: screenWidth * 0.2,
                height: screenHeight * 0.1,
                child: Material(
                  child: FutureBuilder<List<String>>(
                    future: _fetchData("questions"), // 调用异步函数
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // 显示加载指示器
                      } else if (snapshot.hasError) {
                        return Text('加载失败'); // 错误处理
                      } else if (snapshot.hasData) {
                        // 成功返回数据，使用返回的列表
                        return MyDropdown(
                          db: "questions",
                        );
                      } else {
                        return Text('没有数据');
                      }
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class tips extends StatelessWidget {
  final String wisdom = "会当凌绝顶，一览众山小"; //后续这个位置再写动态的，数据从json里面读取，不急。
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          wisdom,
          style: TextStyle(
              fontSize: 24,
              decoration: TextDecoration.none, // 移除下划线
              color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // 阴影颜色
              spreadRadius: 0, // 阴影扩散范围
              blurRadius: 12, // 模糊半径
              offset: Offset(2, 2), // 阴影的偏移量
            ),
          ]),
          child: ElevatedButton(
              onPressed: () {
                debugPrint("下一个，逻辑还没完成");
              },
              child: const Text(
                "Next",
                style: TextStyle(fontSize: 20, color: Colors.blue),
              )),
        ),
      ],
    );
  }
}

class MyDropdown extends StatefulWidget {
  String db;
  MyDropdown({required this.db});

  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  String? _selectedValue; // 当前选中的值

  // 模拟一个异步获取数据的函数
  Future<List<String>> _fetchData() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '127.0.0.1',
      port: 3306,
      user: 'root',
      password: '123456',
      db: 'MemoryHelper',
    ));

    await Future.delayed(Duration(milliseconds: 200));

    var result = await conn.query("SELECT DISTINCT db FROM ${widget.db};");

    List<String> aaaList = result.map((row) => row[0] as String).toList();
    return aaaList;
  }

  // 异步获取下拉列表
  Future<List<String>> _getDropdownList() async {
    return await _fetchData(); // 获取异步数据
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _getDropdownList(), // 获取异步数据
      builder: (context, snapshot) {
        // 处理异步状态
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // 显示加载指示器
        } else if (snapshot.hasError) {
          return Center(child: Text("数据加载失败"));
        } else if (snapshot.hasData) {
          List<String> dropdownItems = snapshot.data!;

          return Center(
            child: DropdownButton<String>(
              value: _selectedValue, // 当前选中的值
              hint: Text('选择一个选项'),
              items: dropdownItems.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      Icon(Icons.storage, color: Colors.blue), // 图标添加
                      SizedBox(width: 10),
                      Text(
                        item,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedValue = newValue; // 更新选中的值
                  print('当前选择: $_selectedValue');
                });
              },
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ), // 按钮文本样式
            ),
          );
        } else {
          return Center(child: Text("没有数据"));
        }
      },
    );
  }
}
