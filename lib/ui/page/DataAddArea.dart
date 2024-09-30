import 'package:flutter/material.dart';
import '../components/UserState.dart';

double screenWidth = 0;
double screenHeight = 0;
final _titleController = TextEditingController();
final _questionController = TextEditingController();
final _contentController = TextEditingController();
List<TextEditingController> _tipsConrollerList = [];
final _priorityController = TextEditingController(); //知识点优先级，影响随机抽题的频率
final _difficultyController = TextEditingController(); //题目难度设置
final _databaseController = TextEditingController(); //题目难度设置

class DataAddArea extends StatefulWidget {
  const DataAddArea.DataAddPage({super.key});

  @override
  State<DataAddArea> createState() => _DataAddAreaState();
}

class _DataAddAreaState extends State<DataAddArea> {
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
                    "新增内容",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
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
                    Row(
                      children: [
                        SizedBox(width: screenWidth * 0.05),
                        DatabaseDropdown(),
                        SizedBox(width: screenWidth * 0.05),
                        difficultyDropdown(),
                        SizedBox(width: screenWidth * 0.05),
                        DatabaseDropdown(),
                        SizedBox(width: screenWidth * 0.05),
                      ],
                    ),
                    TitleInputFeild(),
                    QuestionInputFeild(),
                    ContentInputFeild(),
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

class DatabaseDropdown extends StatefulWidget {
  @override
  State<DatabaseDropdown> createState() => _DatabaseDropdownState();
}

class _DatabaseDropdownState extends State<DatabaseDropdown> {
  String? _selectedValue;
  List<String> _dropdownItems = ["第一个数据库", "第二个选项", "第三个选项"];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth * 0.2,
      child: DropdownButton<String>(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        value: _selectedValue,
        hint: Text(
          '选择要导入的数据库',
          style: TextStyle(fontSize: 20),
        ),
        items: _dropdownItems.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: TextStyle(fontSize: 20),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedValue = newValue; // 更新选中的值
            print(_selectedValue);
          });
        },
      ),
    );
  }
}

class TitleInputFeild extends StatefulWidget {
  @override
  State<TitleInputFeild> createState() => _TitleInputFeildState();
}

class _TitleInputFeildState extends State<TitleInputFeild> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: screenWidth * 0.7,
        // color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: TextField(
            controller: _titleController,
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

class QuestionInputFeild extends StatefulWidget {
  @override
  State<QuestionInputFeild> createState() => _QuestionInputFeildState();
}

class _QuestionInputFeildState extends State<QuestionInputFeild> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: screenWidth * 0.7,
        // color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: TextField(
            controller: _questionController,
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

class ContentInputFeild extends StatefulWidget {
  @override
  State<ContentInputFeild> createState() => _ContentInputFeildState();
}

class _ContentInputFeildState extends State<ContentInputFeild> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: screenWidth * 0.7,
        // color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: TextField(
            controller: _contentController,
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

class difficultyDropdown extends StatefulWidget {
  @override
  _difficultyDropdownState createState() => _difficultyDropdownState();
}

class _difficultyDropdownState extends State<difficultyDropdown> {
  String? _selectedValue = '简单';

  // 定义选项数据
  final List<Map<String, dynamic>> _dropdownItems = [
    {'value': '简单', 'color': Colors.green[100], 'textColor': Colors.green[800]},
    {
      'value': '普通',
      'color': Colors.orange[100],
      'textColor': Colors.orange[800]
    },
    {'value': '困难', 'color': Colors.red[100], 'textColor': Colors.red[800]},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.2, // 设置 DropdownButton 的宽度
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
            value: item['value'],
            child: Container(
              width: double.infinity, // 让选项占满下拉框的宽度
              height: 50, // 设置选项高度
              decoration: BoxDecoration(
                color: item['color'], // 背景颜色
                borderRadius: BorderRadius.circular(20), // 可选，设置圆角
              ),
              alignment: Alignment.center, // 让文本居中
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                item['value'],
                style: TextStyle(
                  color: item['textColor'], // 字体颜色
                  fontSize: 16,
                ),
              ),
            ),
          );
        }).toList(),
        dropdownColor: Colors.grey[200], // 整个下拉菜单的背景颜色
        underline: SizedBox(), // 去掉下划线
        icon: Icon(Icons.arrow_drop_down),
        style: TextStyle(fontSize: 16),
        isExpanded: true, // 让下拉框的宽度占满
      ),
    );
  }
}

// class TipsInputFeild extends StatefulWidget {
//   @override
//   State<TipsInputFeild> createState() => _TipsInputFeildState();
// }

// class _TipsInputFeildState extends State<TipsInputFeild> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         width: screenWidth * 0.7,
//         margin: EdgeInsets.only(top: 20),
//         color: Colors.blue,
//         child: Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: TextField(
//             controller: _tipsController,
//             keyboardType: TextInputType.multiline,
//             minLines: 8,
//             maxLines: 15,
//             decoration: InputDecoration(
//               labelText: "content",
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(20.0), // 圆角半径
//               ),
//             ),
//           ),
//         ));
//   }
// }

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

class addKnowledgePage extends StatefulWidget {
  final int id;
  String curTitle;
  String curDescription;
  String curContent;
  String curNote;
  int curPriority;
  int curDifficulty;
  int curScore;

  addKnowledgePage({
    Key? key,
    required this.id,
    required this.curTitle,
    required this.curDescription,
    required this.curContent,
    required this.curNote,
    required this.curPriority,
    required this.curDifficulty,
    required this.curScore,
  }) : super(key: key);

  @override
  State<addKnowledgePage> createState() => _addKnowledgePageState();
}

class _addKnowledgePageState extends State<addKnowledgePage> {
  Map<String, Color?> difficultyColors = {
    "easy": Colors.green[100],
    "medium": Colors.yellow[100],
    'hard': Colors.red[100]
  };

  Map<int, String> difficultyMap = {0: "简单", 1: "普通", 2: "困难"};

  Map<int, String> priorityMap = {0: "无关紧要", 1: "不可忽视", 2: "至关重要"};

  late TextEditingController titleController;

  late TextEditingController descriptionController;

  late TextEditingController contentController;

  late TextEditingController noteController;

  late TextEditingController scoreController;

  late int selectedPriorityIndex;

  late int selectedDifficultyIndex;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.curTitle);
    descriptionController = TextEditingController(text: widget.curContent);
    contentController = TextEditingController(text: widget.curContent);
    noteController = TextEditingController(text: widget.curNote);
    scoreController = TextEditingController(text: widget.curScore.toString());
    selectedPriorityIndex = widget.curPriority;
    selectedDifficultyIndex = widget.curDifficulty;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.blue[100],
          width: screenWidth * 0.8,
          height: screenHeight * 0.8,
          child: Column(
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
        ),
      ),
    );
  }
}
