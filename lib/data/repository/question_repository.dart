import '../datasources/mysql_datasource.dart';
import '../models/question.dart';

class QuestionRepository {
  final MySQLDataSource _dataSource;

  QuestionRepository(this._dataSource);

  Future<void> addQuestion(Question question) async {
    var connection = await MySQLDataSource.getConnection();

    // 检查 connection 是否为 null
    if (connection != null) {
      await connection.query(
        'INSERT INTO questions (title, description, context, tips, priority, difficulty, cur_state) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [
          question.title,
          question.description,
          question.context,
          question.tips,
          question.priority,
          question.difficulty,
          question.curState
        ],
      );
    } else {
      // 连接为空时处理错误
      throw Exception('MySQL connection failed');
    }
  }
}
