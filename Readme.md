# 一. 项目前端框架

这个项目基于flutter，大概将会是一个**帮助背单词/知识点/错题**的高度自定义工具。

现在越写越像一个数据库管理系统，我为什么不直接调库呢？(恼)

项目结构如图所示

![image-20240930145940896](C:\Users\19170\AppData\Roaming\Typora\typora-user-images\image-20240930145940896.png)

![image-20240930151709402](C:\Users\19170\AppData\Roaming\Typora\typora-user-images\image-20240930151709402.png)

![image-20240930151753918](C:\Users\19170\AppData\Roaming\Typora\typora-user-images\image-20240930151753918.png)

还在开发中，目前打算先重构整个项目的框架，虽然我写的代码虽然称不上是完美无瑕吧，但也能称得上是支离破碎吧:D

实在乱的太令人发指了，再写下去可维护性堪称灾难级，所以没办法，大概准备像这样进行分层

lib/
├── main.dart                // 应用入口
├── ui/                      // UI 层
│   ├── presentation/        // 表示层
│   │   ├── screens/         // 页面
│   │   └── widgets/         // 组件
│   └── routing/             // 路由管理层
├── logic/          // 业务逻辑层
└── data/                    // 数据层
     ├── datasources/         // 数据源
     ├── models/              // 数据模型
     └── repositories/        // 数据仓库

# 二. 数据库结构：

## 为了兼容知识点/单词/错题，我为他们准备了不同的数据库，因为只是个人使用，索引后续再建吧。

### 知识点——questions库

### 单词      ——  words 库   暂未构建

### 错题      ——  errors 库   暂未构建

## 以下是关于实现知识点模块部分的数据库内容

### Tables：

**① questions表，用来存储单个数据库的所有问题** 

- Id 问题的 id，PK，autowired
- db        问题归属的库名称
- title 标题     
- description 对知识点的简述副标题
- content 主体内容 ( answer )                                      《=====  后续在这里面再细分音标之类的
- priority     优先级
- difficulty       难度
- note  笔记一个长string，用来存储字符串，后续update支持md格式
- cur_state  当前掌握状况（根据答题时是否完成 ，也支持对自己手动打分，
- answered_at  最后一次回答的时间
- created_at 创建时间
- updated_at

**② history表，用来记录每道题目的答题记录**  
主表-此表 一对多

- id
- q_id
- content
- answer_time

**③ tips表，用来保存每道题目的提示**
主表-此表一对多

- id
- q_id
- content

**④ tags表，用来保存题库的标签**
单纯作为 tag种类 的存储，具体的关系用下面的数据表处理，方便后续的可拓展性
主表-此表 多对多

- id
- content

**⑤ tags_ref表，用来保存每道题目有哪些标签**

- q_id
- tag_id

**⑥ dataType表，用来保存题库的类型**

- id
- content

**⑦ tags_ref表，用来保存每道题目有哪些标签**

- q_id
- type_id

