# my_project

这个项目基于flutter，大概将会是一个帮助背单词/知识点的高度自定义工具。(还没开始写，先确定一下思路)

项目结构大概分为
1.数据导入层：支持格式JSON（目前不打算拓展其他格式）
数据规范（JSON）：
```json
{
  "words": [
    {
      "word": "example",
      "definition": "a representative form or pattern",
      "partOfSpeech": "noun"
    },
    {
      "word": "elaborate",
      "definition": "involving many careful details",
      "partOfSpeech": "adjective"
    },
    {
      "word": "facilitate",
      "definition": "to make (an action or process) easy or easier",
      "partOfSpeech": "verb"
    },
    {
      "word": "meticulous",
      "definition": "showing great attention to detail; very careful and precise",
      "partOfSpeech": "adjective"
    }
  ]
}
```

（这里的words也可以是其他名字，只要是A:[{a},{b}]）类似的形式就行）
导入之后，自动在每一个最小单位的元素（word）中添加
historyStatus:[],
historyNote:[]
以容纳每一次复习这些知识点/单词的时候，想写下的感悟，以及想对未来自己说的话

2.前端显示：关于具体的前端实现，参考不背单词，寻找好看的图片，然后使用高斯模糊的蒙版，叠加到底层背景图片上面，
大概就是rgba(255,255,255,0.4)的感觉，具体数值待定

3.数据存储：关于数据存储方面直接上mysql吧...json只是导入，后期还应该智能读取excel表的功能。
关于智能读取excel表，我记得我曾经写过一个用txt里预设可能的列名，自动匹配EXCEL表里的前n的行单元格，来自动确定列名行的脚本来着，好像用的python，得研究一下调用问题

4.后端算法：暂时还不知道具体该怎么写，只有一个模糊的思路，利用记忆曲线，根据historyStatus的数据，生成对应权重，
把当前最高权重的知识点/单词推送给用户，辅助记忆

5.补充功能：支持单个知识点表单输入。

ps:现就写个思路吧，后面一边学一边开发

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
