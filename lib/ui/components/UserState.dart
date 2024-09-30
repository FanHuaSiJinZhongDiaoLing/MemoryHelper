import 'package:flutter/material.dart';
import '../page/MainPage.dart';

class UserState extends StatelessWidget {
  const UserState({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取主题颜色
    final Color primaryColor = Colors.blue;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: 260,
      height: 60,
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
                width: 45,
                height: 45,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/pic/user.jpeg'), // 使用本地图片
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: screenWidth / 126.4,
              ), // 图片和文本之间的间距

              // 文本
              Text(
                'Ru_Meng_OvO',
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFf3f3f3),
                    decoration: TextDecoration.none),
              ),
              SizedBox(
                width: screenWidth / 126.4,
              ), // 文本和按钮之间的间距

              // 按钮
              SizedBox(
                width: 60,
                height: 30,
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint('按钮被点击');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Datapage()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, // 去除按钮内边距
                  ),
                  child: Text(
                    '更多',
                    style: TextStyle(fontSize: 10, color: primaryColor),
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
