import 'package:flutter/material.dart';
import '../../data/models/question.dart';
import '../../data/repository/question_repository.dart';
import '../../data/datasources/mysql_datasource.dart';

class QuestionForm extends StatefulWidget {
  @override
  _QuestionFormState createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contextController = TextEditingController();
  final _tipsController = TextEditingController();
  final _priorityController = TextEditingController();
  final _difficultyController = TextEditingController();
  final _curStateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Question"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            QuestionForm(),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _contextController,
              decoration: InputDecoration(labelText: 'Context'),
            ),
            TextField(
              controller: _tipsController,
              decoration: InputDecoration(labelText: 'Tips'),
            ),
            TextField(
              controller: _priorityController,
              decoration: InputDecoration(labelText: 'Priority'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _difficultyController,
              decoration: InputDecoration(labelText: 'Difficulty'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _curStateController,
              decoration: InputDecoration(labelText: 'Current State'),
            ),
            SizedBox(height: 20),
            QueryButton(),
            ElevatedButton(
              onPressed: () async {
                // 提交表单并新增问题
                var question = Question(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  context: _contextController.text,
                  tips: _tipsController.text,
                  priority: int.parse(_priorityController.text),
                  difficulty: int.parse(_difficultyController.text),
                  curState: _curStateController.text,
                );

                var repository = QuestionRepository(MySQLDataSource());
                await repository.addQuestion(question);

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Question added successfully!')));
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class TestQuery {
  Future<void> fetchFirstThreeQuestions() async {
    try {
      // 获取数据库连接
      var connection = await MySQLDataSource.getConnection();

      if (connection != null) {
        // 查询前3条记录
        var results = await connection.query('SELECT * FROM questions LIMIT 3');

        // 打印查询结果
        for (var row in results) {
          print(
              'ID: ${row['id']}, Title: ${row['title']}, Description: ${row['description']}, Context: ${row['context']}, Tips: ${row['tips']}, Priority: ${row['priority']}, Difficulty: ${row['difficulty']}, Current State: ${row['cur_state']}');
        }
      } else {
        throw Exception('MySQL connection failed');
      }
    } catch (e) {
      // 处理查询中的错误
      print('Error: $e');
    }
  }
}

class QueryButton extends StatelessWidget {
  const QueryButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // 创建 TestQuery 实例
        var testQuery = TestQuery();

        // 调用查询方法并在控制台打印结果
        await testQuery.fetchFirstThreeQuestions();
      },
      child: Text('Fetch First 3 Questions'),
    );
  }
}
