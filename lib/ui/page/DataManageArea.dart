import '../components/UserState.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:textfield_tags/textfield_tags.dart'; //有计划加，但不应该是现在

final pool = MySQLConnectionPool(
  host: '127.0.0.1',
  port: 3306,
  userName: 'root',
  password: '123456',
  maxConnections: 10,
  databaseName: 'memoryhelper', // optional,
);

double screenWidth = 0;
double screenHeight = 0;

class StringHolder {
  String? value;
  StringHolder(this.value);
}

StringHolder selectedDB = StringHolder("所有数据库");

final DB_NameController = TextEditingController(); //inputfeild
final DB_AuthorController = TextEditingController();

class DatabaseManageArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    debugPrint(
        "管理页面的各参数：" + screenWidth.toString() + "|" + screenHeight.toString());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.1,
            child: Stack(
              children: [
                Center(
                  child: Text(
                    "管理知识库",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                    top: screenWidth * 0.008,
                    right: screenWidth * 0.008,
                    child: UserState()),
              ],
            ),
          ),
          Center(
            child: Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.9,
                color: Color.fromARGB(255, 233, 233, 233),
                child: MannagePart()),
          ),
        ],
      ),
    );
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

class InsertButton extends StatefulWidget {
  Future<void> Function(
      String newTitle,
      String newDescription,
      String newContent,
      String newNote,
      int newPriority,
      int newDifficulty,
      String newScoreStr) insertFunc; //用来在dialog弹窗中新增按钮中使用的函数

  final void Function(
      Future<void> Function(
              String newTitle,
              String newDescription,
              String newContent,
              String newNote,
              int newPriority,
              int newDifficulty,
              String newScoreStr)
          insertFunc) openAddDialog;
  InsertButton({required this.insertFunc, required this.openAddDialog});

  @override
  State<InsertButton> createState() => _InsertButtonState();
}

class _InsertButtonState extends State<InsertButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.green[400],
          elevation: 10,
          backgroundColor: Colors.green[600],
          overlayColor: Colors.green[900],
        ),
        onPressed: () {
          debugPrint("新增按钮触发");
          widget.openAddDialog(widget.insertFunc);
        },
        icon: Icon(Icons.add, color: Colors.white), // 加号图标
        label: Text(
          "新增数据",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ));
  }
}

class MannagePart extends StatefulWidget {
  @override
  _MannagePartState createState() => _MannagePartState();
}

class _MannagePartState extends State<MannagePart> {
  List<Map<String, dynamic>> _data = [];
  int _currentPage = 0;
  int _totalPages = 0;
  int _totalRows = 0;

  final int _rowsPerPage = 10; // 每行10条
  String _searchQuery = ''; // 搜索关键字

  Map<String, Color?> difficultyColors = {
    "easy": Colors.green[100],
    "medium": Colors.yellow[100],
    'hard': Colors.red[100]
  };

  Map<int, String> difficultyMap = {0: "简单", 1: "普通", 2: "困难"};
  Map<int, String> priorityMap = {0: "无关紧要", 1: "不可忽视", 2: "至关重要"};

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData(_currentPage, _searchQuery);
  }

  // 获取数据，支持分页和模糊查询
  Future<void> _fetchData(int page, String queryStr) async {
    try {
      int offset = page * _rowsPerPage;
      var results;
      print("当前选中的数据库为：${selectedDB.value}");
      if (selectedDB.value == "所有数据库") {
        //默认情况下，全选数据库
        results = await pool.execute(
            'SELECT * FROM questions WHERE title LIKE "%$queryStr%" LIMIT $_rowsPerPage OFFSET $offset');
      } else {
        //如果制定了数据，那么则只选择指定的数据库
        results = await pool.execute(
            'SELECT * FROM questions WHERE db = "${selectedDB.value}" and title LIKE "%$queryStr%" LIMIT $_rowsPerPage OFFSET $offset');
      }

      print(results);
      var countResults = await pool.execute(
          'SELECT COUNT(*) as count FROM questions WHERE title LIKE "%$queryStr%"');
      for (var row in countResults.rows) {
        _totalRows = int.parse(row.colByName('count') ?? '0');
      }
      print('Count: $countResults');
      // 计算总页数
      setState(() {
        _totalPages = (_totalRows / _rowsPerPage).ceil();
      });

      List<Map<String, dynamic>> newData = [];
      for (var row in results.rows) {
        newData.add({
          'id': int.parse(row.colByName('id') ?? '0'),
          'db': row.colByName('db'),
          'title': row.colByName('title'),
          'description': row.colByName('description'),
          'content': row.colByName('content'),
          'priority': int.parse(row.colByName('priority') ?? '0'),
          'difficulty': int.parse(row.colByName('difficulty') ?? '0'),
          'note': row.colByName('note'),
          'score': int.parse(row.colByName('score') ?? '0'),
          'created_at': row.colByName('created_at'),
          'updated_at': row.colByName('updated_at'),
          'answered_at': row.colByName('answered_at')
        });
      }
      // print(newData[3].runtimeType);
      // print(newData[3]['difficulty'].runtimeType);
      setState(() {
        _data = newData;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  // 删除行
  Future<void> _deleteRow(int id) async {
    await Future.delayed(Duration(milliseconds: 200));

    try {
      await pool.execute('DELETE FROM questions WHERE id = $id LIMIT 1000');
      _fetchData(_currentPage, _searchQuery); // 删除后刷新数据
    } catch (e) {
      print('Error: $e');
    }
  }

  // 修改行数据
  Future<void> _updateRow(
      int id,
      String newTitle,
      String newDescription,
      String newContent,
      String newNote,
      int newPriority,
      int newDifficulty,
      String newScoreStr) async {
    int newScore = int.parse(newScoreStr);
    DateTime curTime = DateTime.now();
    // String formattedTime =
    //     '"${curTime.year.toString().padLeft(4, '0')}-${curTime.month.toString().padLeft(2, '0')}-${curTime.day.toString().padLeft(2, '0')} ${curTime.hour.toString().padLeft(2, '0')}:${curTime.minute.toString().padLeft(2, '0')}:${curTime.second.toString().padLeft(2, '0')}"';
    String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(curTime);
    String str =
        'UPDATE questions SET title = "$newTitle", description = "$newDescription" , content = "$newContent", priority = $newPriority,difficulty= $newDifficulty, note = "$newNote", updated_at = "$formattedTime",score = $newScore WHERE id = $id;';
    // print(str);
    // print(
    //     'UPDATE questions SET title = 1111122, description = 33 , content = 33, priority = 2,difficulty=2, note = 61,updated_at = "2024-09-18 09:03:22" ,score = 71112 WHERE id = 13;');
    try {
      await Future.delayed(Duration(milliseconds: 200));
      await pool.execute(str);
      _fetchData(_currentPage, _searchQuery); // 修改后刷新数据
      print("===update完成===");
    } catch (e) {
      print("===update失败===");
      print('Error: $e');
    }
  }

  // 增加行数据
  Future<void> _insertRow(
      String newTitle,
      String newDescription,
      String newContent,
      String newNote,
      int newPriority,
      int newDifficulty,
      String newScoreStr) async {
    int newScore = int.parse(newScoreStr);
    DateTime curTime = DateTime.now();
    String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(curTime);
    print(formattedTime);
    String str =
        'INSERT INTO questions (title,description,content,note,priority,difficulty,score,created_at) VALUES ($newTitle,$newDescription,$newContent,$newNote,$newPriority,$newDifficulty,$newScore,"$formattedTime")';
    try {
      await pool.execute(str);
      _fetchData(_currentPage, _searchQuery); // 修改后刷新数据
      print("===insert完成===");
    } catch (e) {
      print("===insert失败===");
      print('Error: $e');
    }
  }

  // 下一页
  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      setState(() {
        _currentPage++;
        _fetchData(_currentPage, _searchQuery);
      });
    }
  }

  // 上一页
  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        _fetchData(_currentPage, _searchQuery);
      });
    }
  }

  // 修改弹窗
  void _showAddDialog(
      Future<void> Function(
              String newTitle,
              String newDescription,
              String newContent,
              String newNote,
              int newPriority,
              int newDifficulty,
              String newScoreStr)
          insertFunc) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController contentController = TextEditingController();
    TextEditingController noteController = TextEditingController();
    TextEditingController scoreController = TextEditingController();

    int selectedPriorityIndex = 0;
    int selectedDifficultyIndex = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Row'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                //标题输入框
                controller: titleController,
                decoration: InputDecoration(labelText: '标题'),
              ),
              TextField(
                //简述输入框
                controller: descriptionController,
                decoration: InputDecoration(labelText: '简述'),
              ),
              TextField(
                //内容输入框
                controller: contentController,
                decoration: InputDecoration(labelText: '主体内容'),
              ),
              TextField(
                //笔记输入框
                controller: noteController,
                decoration: InputDecoration(labelText: '笔记'),
              ),
              StatefulBuilder(
                // 使用 StatefulBuilder 来包装 DropdownButton
                builder: (BuildContext context, StateSetter setState) {
                  return DropdownButton<int>(
                    value: selectedPriorityIndex,
                    items: priorityMap.entries.map((entry) {
                      return DropdownMenuItem<int>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      // 当用户选择新的状态时，更新 selectedPriority
                      if (newValue != null) {
                        setState(() {
                          selectedPriorityIndex = newValue;
                        });
                      }
                    },
                  );
                },
              ),
              StatefulBuilder(
                // 使用 StatefulBuilder 来包装 DropdownButton
                builder: (BuildContext context, StateSetter setState) {
                  return DropdownButton<int>(
                    //难度下拉框
                    value: selectedDifficultyIndex,
                    items: difficultyMap.entries.map((entry) {
                      return DropdownMenuItem<int>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      // 当用户选择新的状态时，更新 selectedDifficulty
                      if (newValue != null) {
                        setState(() {
                          selectedDifficultyIndex = newValue;
                        });
                      }
                    },
                  );
                },
              ),
              TextField(
                //进度输入框
                controller: scoreController,
                decoration: InputDecoration(labelText: '熟练度'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                _insertRow(
                    titleController.text,
                    descriptionController.text,
                    contentController.text,
                    noteController.text,
                    selectedPriorityIndex,
                    selectedDifficultyIndex,
                    scoreController.text);
                //测试打印部分
                // print(id.toString() +
                //     " " +
                //     titleController.text +
                //     "\n" +
                //     descriptionController.text +
                //     "\n" +
                //     contentController.text +
                //     "\n" +
                //     noteController.text +
                //     "\n" +
                //     selectedPriorityIndex.toString() +
                //     "\n" +
                //     selectedDifficultyIndex.toString() +
                //     "\n" +
                //     scoreController.text);
                Navigator.of(context).pop();
                _fetchData(_currentPage, _searchQuery); // 修改后刷新数据
              },
              child: Text('修改'),
            ),
          ],
        );
      },
    );
  }

  // 修改弹窗
  void _showUpdateDialog(
      int id,
      String curTitle,
      String curDescription,
      String curContent,
      String curNote,
      int curPriority,
      int curDifficulty,
      int curScore) {
    TextEditingController titleController =
        TextEditingController(text: curTitle);
    TextEditingController descriptionController =
        TextEditingController(text: curContent);
    TextEditingController contentController =
        TextEditingController(text: curContent);
    TextEditingController noteController = TextEditingController(text: curNote);
    TextEditingController scoreController =
        TextEditingController(text: curScore.toString());

    int selectedPriorityIndex = curPriority;
    int selectedDifficultyIndex = curDifficulty;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Row'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                //标题输入框
                controller: titleController,
                decoration: InputDecoration(labelText: '标题'),
              ),
              TextField(
                //简述输入框
                controller: descriptionController,
                decoration: InputDecoration(labelText: '简述'),
              ),
              TextField(
                //内容输入框
                controller: contentController,
                decoration: InputDecoration(labelText: '主体内容'),
              ),
              TextField(
                //笔记输入框
                controller: noteController,
                decoration: InputDecoration(labelText: '笔记'),
              ),
              StatefulBuilder(
                // 使用 StatefulBuilder 来包装 DropdownButton
                builder: (BuildContext context, StateSetter setState) {
                  return DropdownButton<int>(
                    value: selectedPriorityIndex,
                    items: priorityMap.entries.map((entry) {
                      return DropdownMenuItem<int>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      // 当用户选择新的状态时，更新 selectedPriority
                      if (newValue != null) {
                        setState(() {
                          selectedPriorityIndex = newValue;
                        });
                      }
                    },
                  );
                },
              ),
              StatefulBuilder(
                // 使用 StatefulBuilder 来包装 DropdownButton
                builder: (BuildContext context, StateSetter setState) {
                  return DropdownButton<int>(
                    //难度下拉框
                    value: selectedDifficultyIndex,
                    items: difficultyMap.entries.map((entry) {
                      return DropdownMenuItem<int>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      // 当用户选择新的状态时，更新 selectedDifficulty
                      if (newValue != null) {
                        setState(() {
                          selectedDifficultyIndex = newValue;
                        });
                      }
                    },
                  );
                },
              ),
              TextField(
                //进度输入框
                controller: scoreController,
                decoration: InputDecoration(labelText: '熟练度'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateRow(
                    id,
                    titleController.text,
                    descriptionController.text,
                    contentController.text,
                    noteController.text,
                    selectedPriorityIndex,
                    selectedDifficultyIndex,
                    scoreController.text);
                //测试打印部分
                // print(id.toString() +
                //     " " +
                //     titleController.text +
                //     "\n" +
                //     descriptionController.text +
                //     "\n" +
                //     contentController.text +
                //     "\n" +
                //     noteController.text +
                //     "\n" +
                //     selectedPriorityIndex.toString() +
                //     "\n" +
                //     selectedDifficultyIndex.toString() +
                //     "\n" +
                //     scoreController.text);
                Navigator.of(context).pop();
                _fetchData(_currentPage, _searchQuery); // 修改后刷新数据
              },
              child: Text('修改'),
            ),
          ],
        );
      },
    );
  }

  Color? _getBGC(int curDifficulty) {
    switch (curDifficulty) {
      case 0:
        return difficultyColors['easy'];
      case 1:
        return difficultyColors['medium'];
      case 2:
        return difficultyColors['hard'];
    }
    return Color.fromARGB(255, 254, 247, 255);
  }

  String _getPercent(double num) {
    if (num >= 100) {
      return "100.0%";
    } else if (num >= 10) {
      return num.toStringAsFixed(1) + "% ";
    } else {
      return num.toStringAsFixed(1) + "%  ";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Align(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1)),
                      height: 0.1 * screenHeight,
                      width: 0.2 * screenWidth,
                      child: MyDropdown(
                        db: 'questions',
                        selectedHolder: selectedDB,
                        onPressedFunc: _fetchData,
                        page: _currentPage,
                        queryStr: _searchQuery,
                      )),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1)),
                    height: 0.1 * screenHeight,
                    width: 0.2 * screenWidth,
                    child: Center(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Search',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              setState(() {
                                _searchQuery = _searchController.text;
                                _currentPage = 0; // 搜索时回到第一页
                                _fetchData(_currentPage, _searchQuery);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 0.1 * screenHeight,
                    width: 0.2 * screenWidth,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1)),
                    child: SizedBox(
                        height: 0.4,
                        width: 0.04,
                        child: Center(
                            child: InsertButton(
                          insertFunc: _insertRow,
                          openAddDialog: _showAddDialog,
                        ))),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _data.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _data.length,
                    itemBuilder: (context, index) {
                      var item = _data[index];
                      return Stack(children: [
                        Container(
                          decoration: BoxDecoration(
                            color: _getBGC(item['difficulty']),
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black, // 黑色边框
                                width: 1.0, // 1px 宽度
                              ),
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              '${item['title']}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('简述： ${item['description']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _showUpdateDialog(
                                      item['id'],
                                      item['title'] ?? "",
                                      item['description'] ?? "",
                                      item['content'] ?? "",
                                      item['note'] ?? "",
                                      item['priority'] ?? 0,
                                      item['difficulty'] ?? 0,
                                      item['score'] ?? 0,
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteRow(item['id']);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                              padding: EdgeInsets.only(right: 120),
                              height: 40,
                              width: 400,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("掌握程度："),
                                  Expanded(
                                    child: LinearProgressIndicator(
                                      value: item['score'] / 100.0, // 设置进度
                                      backgroundColor: Colors.grey[300],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        item['score'] == 0.6
                                            ? Colors.green
                                            : Colors.blue, // 动态和静态颜色区分
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        )
                      ]);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _previousPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // 按钮背景色
                    foregroundColor: Colors.white, // 文字颜色
                    padding: EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12), // 按钮内边距
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // 圆角
                    ),
                    elevation: 5, // 按钮阴影
                  ),
                  child: Text(
                    '上一页',
                    style: TextStyle(
                      fontSize: 16, // 字体大小
                      fontWeight: FontWeight.bold, // 字体加粗
                    ),
                  ),
                ),
                Text(
                  '每页 $_rowsPerPage 条  第 ${_currentPage + 1} 页/共 $_totalPages 页  $_totalRows 条 ',
                  style: TextStyle(
                    fontSize: 16, // 字体大小
                    fontWeight: FontWeight.w500, // 字体粗细
                    color: Colors.black87, // 字体颜色
                  ),
                ),
                ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // 按钮背景色
                    foregroundColor: Colors.white, // 文字颜色
                    padding: EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12), // 按钮内边距
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // 圆角
                    ),
                    elevation: 5, // 按钮阴影
                  ),
                  child: Text(
                    '下一页',
                    style: TextStyle(
                      fontSize: 16, // 字体大小
                      fontWeight: FontWeight.bold, // 字体加粗
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MyDropdown extends StatefulWidget {
  String db;
  StringHolder selectedHolder; // 当前选中的值
  Future<void> Function(int page, String queryStr)
      onPressedFunc; //这个变量以及下面三个变量是用来在更改选定的数据库后,更新整个显示页面的
  int page;
  String queryStr;
  MyDropdown(
      {required this.db,
      required this.selectedHolder,
      required this.onPressedFunc,
      required this.page,
      required this.queryStr});

  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  // 模拟一个异步获取数据的函数
  Future<List<String>> _fetchDropdownList() async {
    await Future.delayed(Duration(milliseconds: 200));
    var results = await pool.execute("SELECT DISTINCT db FROM ${widget.db};");
    List<String> dbList = ["所有数据库"];

    for (var row in results.rows) {
      dbList.add(row.colByName('db') as String); // 假设 'db' 是字符串类型
    }

    return dbList; // 返回结果
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _fetchDropdownList(), // 异步获取下拉框内部成员
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
              value: widget.selectedHolder.value, // 当前选中的值
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
                  widget.selectedHolder.value = newValue; // 更新选中的值
                  widget.onPressedFunc(widget.page, widget.queryStr);
                  print('当前选择: ${widget.selectedHolder.value}');
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
