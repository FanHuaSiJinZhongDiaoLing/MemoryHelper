import 'package:flutter/material.dart';
import 'package:memory_helper001/ui/page/DataManageArea.dart';
import 'StudyPage.dart';
import 'DataAddArea.dart';
import 'DBAddArea.dart';

class Datapage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScaffoldWithNavigationRail(),
    );
  }
}

class ScaffoldWithNavigationRail extends StatefulWidget {
  @override
  _ScaffoldWithNavigationRailState createState() =>
      _ScaffoldWithNavigationRailState();
}

class _ScaffoldWithNavigationRailState
    extends State<ScaffoldWithNavigationRail> {
  int _selectedIndex = 0;

  // 页面列表
  final List<Widget> _pages = [
    StudyPage(),
    DatabaseAddArea(),
    DatabaseManageArea(),
    Center(child: Text('偏好设置', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            backgroundColor: const Color.fromARGB(255, 30, 30, 30), // 背景颜色
            selectedIconTheme: IconThemeData(color: Colors.blue, size: 32),
            unselectedIconTheme: IconThemeData(color: Colors.white70, size: 24),
            selectedLabelTextStyle: TextStyle(color: Colors.blue),
            unselectedLabelTextStyle: TextStyle(color: Colors.white70),
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.menu_book),
                selectedIcon: Icon(Icons.menu_book_rounded),
                label: Text('开始学习'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.add),
                selectedIcon: Icon(Icons.add),
                label: Text('知识库添加'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.storage),
                selectedIcon: Icon(Icons.storage_rounded),
                label: Text('知识库管理'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                selectedIcon: Icon(Icons.settings),
                label: Text('偏好设置'),
              ),
            ],
          ),
          VerticalDivider(thickness: 1, width: 1),
          // 页面内容展示
          Expanded(
            child: Container(
              color: Colors.blueGrey[50],
              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
