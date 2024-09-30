import 'package:mysql1/mysql1.dart';
import 'package:flutter/material.dart';

class MySQLDataSource {
  // 单例模式管理数据库连接
  static MySqlConnection? _connection;

  // 去掉 BuildContext 参数
  static Future<MySqlConnection?> getConnection() async {
    try {
      if (_connection == null) {
        var settings = ConnectionSettings(
          host: '127.0.0.1',
          port: 3306,
          user: 'root',
          password: '123456',
          db: 'MemoryHelper',
        );
        _connection = await MySqlConnection.connect(settings);
        debugPrint("连接成功");
      }
      return _connection;
    } catch (e) {
      debugPrint("连接失败: $e");
      return null;
    }
  }

  // 关闭连接
  static Future<void> closeConnection() async {
    await _connection?.close();
    _connection = null;
  }
}
