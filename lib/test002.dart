import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class MySQLDataSource {
  static MySqlConnection? _connection;

  // 获取连接
  static Future<MySqlConnection> getConnection() async {
    if (_connection == null) {
      var settings = ConnectionSettings(
        host: '127.0.0.1',
        port: 3306,
        user: 'root',
        password: '123456',
        db: 'MemoryHelper',
      );
      _connection = await MySqlConnection.connect(settings);
    }
    debugPrint("连接成功");
    return _connection!;
  }

  // 关闭连接
  static Future<void> closeConnection() async {
    await _connection?.close();
    _connection = null;
  }
}

class QuestionRepository {
  final MySQLDataSource _dataSource;

  QuestionRepository(this._dataSource);

  // 获取 questions 表的所有内容
  Future<void> getAllQuestions() async {
    var connection = await MySQLDataSource.getConnection();

    var results = await connection.query('SELECT * FROM questions');

    // 打印表格的每一行
    for (var row in results) {
      print(
          'ID: ${row['id']}, Title: ${row['title']}, Description: ${row['description']}, Context: ${row['context']}, Tips: ${row['tips']}, Priority: ${row['priority']}, Difficulty: ${row['difficulty']}, Current State: ${row['cur_state']}');
    }
  }
}

void main() async {
  // 初始化数据源
  var repository = QuestionRepository(MySQLDataSource());

  // 验证连接并打印 questions 表的内容
  await repository.getAllQuestions();

  // 关闭连接
  await MySQLDataSource.closeConnection();
}
