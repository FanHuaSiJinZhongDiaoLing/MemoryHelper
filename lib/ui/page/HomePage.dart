import 'package:flutter/material.dart';

import '../components/UserState.dart';
import 'StudyPage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Stack(
        children: [
          const Positioned(top: 20, right: 20, child: Menu()),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StartButton(),
              const SizedBox(height: 20), // 用于分隔两个组件
              tips(),
              // Menu()
            ],
          ),
        ],
      )),
    );
  }
}

class StartButton extends StatelessWidget {
  final bool isVisible;

  StartButton({this.isVisible = true});

  @override
  Widget build(BuildContext context) {
    // 获取主题颜色
    final Color primaryColor = Theme.of(context).primaryColor;

    if (!isVisible) {
      return SizedBox.shrink();
    }

    return Center(
      child: SizedBox(
        width: 400,
        height: 120,
        child: ElevatedButton(
          onPressed: () {
            debugPrint("点击开始学习");
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => StudyPage()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
          ),
          child: Text(
            "开始学习",
            style: Theme.of(context).textTheme.displayLarge,
          ),
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
          style: TextStyle(fontSize: 24),
        ),
        const SizedBox(
          width: 20,
        ),
        ElevatedButton(
            onPressed: () {
              debugPrint("下一个，逻辑还没完成");
            },
            child: const Text(
              "Next",
              style: TextStyle(fontSize: 20, color: Colors.blue),
            )),
      ],
    );
  }
}
