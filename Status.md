# 今天的学习目标

## 1.把整个页面的前端样式排版 如果不能相对布局呢就把那部分写死，完成windows端

## tips: 最少要把整个框架的每个页面大部分写好

JSON数据导入可以晚点完成
已经实现简单的了，不急（）

### ①HomePage页面

居中的 startButton 相对下面的句子
右上角的菜单组件包括：

1. 头像
2. 用户名
3. 更多功能按钮（暂时先直接导航到数据管理页面）

### ②StudyPage页面

![image-20240905124456756](C:\Users\19170\AppData\Roaming\Typora\typora-user-images\image-20240905124456756.png)

![image-20240905125031878](C:\Users\19170\AppData\Roaming\Typora\typora-user-images\image-20240905125031878.png)

![image-20240905125050741](C:\Users\19170\AppData\Roaming\Typora\typora-user-images\image-20240905125050741.png)



选取自定义数量的知识点（默认10个一组进行抽查）放入tmp链表的数据结构中。
数据暂时存储在前端，今天暂时只用静态数据调试

前端存储的JSON字段包括

- title 标题

- description 问题简述 ( question

- context 主体内容 ( answer )                                      《=====  后续在这里面再细分音标之类的

- tips 提示

- history_answer [ ]  历史回答（链表

- history_note [ ]  历史笔记 （链表 每次答题都可以写一些笔记，给未来的自己来看

- priority     优先级

- difficulty       难度

- cur_state  当前掌握状况（根据答题时是否完成 ，也支持对自己手动打分，
  按自定义的算法去自动管理每道题的状态，按日期衰减之类的动态更新，

  可选五个等级

  - 略知一二
  - 初窥门径
  - 驾轻就熟
  - 炉火纯青（前四个随时间自然衰减
  - 登峰造极（不用只能手动标记，再背了

  最后按照state随机推送，计划复习

支持OCR批量导入，拍照把识别到的图片全部导入到指定文件夹下，然后调用python脚本，生成JSON数据，预览修改，确认无误之后存入数据库。





### ③DataAddPage页面

![image-20240905134338467](C:\Users\19170\AppData\Roaming\Typora\typora-user-images\image-20240905134338467.png)

把页面画好之后，今天就可以不用管他了，后续短期只考虑单机使用，后续如果要update可以搞个服务器出来，大家一起用。

### ④DataEditPage页面

![image-20240905132123231](C:\Users\19170\AppData\Roaming\Typora\typora-user-images\image-20240905132123231.png)

这部分就浏览json数据库，将所有拿到的内容每页n条的方式 打印出来就行了
显示的字段包括

- title
- history_answer_time[-1]         《==== 最后一次回答的时间
- description
- priority     优先级
- difficulty   难度
- cur_state  当前掌握状况（根据答题时是否完成 对自己手动打分，
  算法可以选择每道题的评分，按日期衰减之类的动态更新，
  最后按照state随机推送，计划复习



