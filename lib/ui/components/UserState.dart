import 'package:flutter/material.dart';
import '../page/DataPage.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取主题颜色
    final Color primaryColor = Colors.blue;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: 240 * screenWidth / 1264,
      height: 60 * screenHeight / 681,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 圆形图片容器
              Container(
                width: 40 * screenWidth / 1264,
                height: 40 * screenHeight / 681,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/pic/user.jpeg'), // 使用本地图片
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 10 * screenWidth / 1264,
              ), // 图片和文本之间的间距

              // 文本
              Text(
                'Ru_Meng_OvO',
                style: TextStyle(
                    fontSize: 16 * screenWidth / 1264 * screenHeight / 681,
                    color: Color(0xFFf3f3f3),
                    decoration: TextDecoration.none),
              ),
              SizedBox(
                width: 10 * screenWidth / 1264,
              ), // 文本和按钮之间的间距

              // 按钮
              SizedBox(
                width: 40 * screenWidth / 1264,
                height: 20 * screenHeight / 681,
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint('按钮被点击');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, // 去除按钮内边距
                  ),
                  child: Text(
                    '更多',
                    style: TextStyle(
                        fontSize: 10 * screenWidth / 1264 * screenHeight / 681,
                        color: Colors.blue),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
