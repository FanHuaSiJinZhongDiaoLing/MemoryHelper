import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class PaginatedDataScreen extends StatefulWidget {
  @override
  _PaginatedDataScreenState createState() => _PaginatedDataScreenState();
}

class _PaginatedDataScreenState extends State<PaginatedDataScreen> {
  List<Map<String, dynamic>> _data = [];
  int _currentPage = 0;
  int _totalPages = 0;
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
  Future<void> _fetchData(int page, String query) async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '127.0.0.1',
      port: 3306,
      user: 'root',
      password: '123456',
      db: 'MemoryHelper',
    ));

    try {
      int offset = page * _rowsPerPage;

      await Future.delayed(Duration(milliseconds: 200));

      // 统计符合条件的数据总数
      var totalRowsResult = await conn.query(
          'SELECT COUNT(*) FROM questions WHERE title LIKE ?', ['%$query%']);
      int totalRows = totalRowsResult.first[0];

      // 计算总页数
      setState(() {
        _totalPages = (totalRows / _rowsPerPage).ceil();
      });

      // 获取当前页的数据
      var results = await conn.query(
        'SELECT * FROM questions WHERE title LIKE ? LIMIT $_rowsPerPage OFFSET $offset',
        ['%$query%'],
      );

      List<Map<String, dynamic>> newData = [];
      for (var row in results) {
        newData.add({
          'id': row[0],
          'db': row[1],
          'title': row[2],
          'description': row[3],
          'content': row[4],
          'priority': row[5],
          'difficulty': row[6],
          'note': row[7],
          'score': row[8],
          'created_at': row[9],
          'updated_at': row[10],
          'answer_at': row[11]
        });
      }
      // print(newData[3].runtimeType);
      // print(newData[3]['difficulty'].runtimeType);
      setState(() {
        _data = newData;
      });
    } catch (e) {
      print('Error: $e');
    } finally {
      await conn.close();
    }
  }

  // 删除行
  Future<void> _deleteRow(int id) async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '127.0.0.1',
      port: 3306,
      user: 'root',
      password: 'yourpassword',
      db: 'MemoryHelper',
    ));

    try {
      await conn.query('DELETE FROM questions WHERE id = ?', [id]);
      _fetchData(_currentPage, _searchQuery); // 删除后刷新数据
    } catch (e) {
      print('Error: $e');
    } finally {
      await conn.close();
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
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '127.0.0.1',
      port: 3306,
      user: 'root',
      password: '123456',
      db: 'MemoryHelper',
    ));
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
      await conn.query(str);
      _fetchData(_currentPage, _searchQuery); // 修改后刷新数据
    } catch (e) {
      print('Error: $e');
    } finally {
      await conn.close();
      print("===update完成===");
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
  // Color? _print1(dynamic aaa) {
  //   print(aaa.runtimeType);
  //   print(aaa);
  //   print(aaa.first);
  //   return Color.fromARGB(255, 254, 247, 255);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paginated Data View with Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                                      item['title'],
                                      item['description'],
                                      item['content'],
                                      item['note'],
                                      item['priority'],
                                      item['difficulty'],
                                      item['score'],
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
                  child: Text('上一页'),
                ),
                Text('第 ${_currentPage + 1} 页/共 $_totalPages 页'),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: Text('下一页'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
