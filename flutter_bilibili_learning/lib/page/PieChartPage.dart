import 'dart:math';

import 'package:flutter/material.dart';

///    author : jiangxk
///    e-mail : jxklongmao@gmai.com
///    date   : 2020/12/7 22:53
///    desc   : 扇形图
///    version: 1.0
class PieChartWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PieChartState();
  }
}

class PieChartState extends State<PieChartWidget> {
  Color mainColor = Colors.blueGrey;
  List _list = [
    {'title': '生活费', 'number': 200, 'color': Colors.blue},
    {'title': '交通费', 'number': 300, 'color': Colors.yellow},
    {'title': '贷款费', 'number': 500, 'color': Colors.red},
    {'title': '游玩费', 'number': 200, 'color': Colors.orange},
    {'title': '通讯费', 'number': 100, 'color': Colors.deepPurple}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          height: 260,
          width: MediaQuery.of(context).size.width,
          color: mainColor,
          child: buildRow(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }

  ///构建Row
  buildRow() {
    //左右排列
    return Row(
      children: [
        //权重适配 占用宽度5:6
        Expanded(flex: 5, child: buildLeftColumn()),
        Expanded(
            flex: 6,
            //层叠布局
            child: Stack(
              children: [
                //第一层
                Container(
                  //内边距
                  padding: EdgeInsets.all(22),
                  //边框装饰
                  decoration:
                      BoxDecoration(color: mainColor, shape: BoxShape.circle,
                          //阴影
                          boxShadow: [
                        BoxShadow(
                            //模糊颜色
                            color: Colors.white.withOpacity(0.3),
                            //模糊半径
                            spreadRadius: -8,
                            //阴影偏移量
                            offset: Offset(-5, -5),
                            //模糊度
                            blurRadius: 30),
                        BoxShadow(
                            color: Colors.blue[300],
                            spreadRadius: 2,
                            offset: Offset(7, 7),
                            blurRadius: 20)
                      ]),
                  child: CustomPaint(
                    size: Size(200, 200),
                    painter: CustomShapePainter(_list),
                  ),
                ),
                //第一层
              ],
            )),
      ],
    );
  }

  ///构建左边图例
  buildLeftColumn() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      //图例排列
      children: _list.map((data) {
        return Container(
          //设置水平 垂直Pading
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                width: 10,
                height: 10,
                decoration:
                    BoxDecoration(color: data['color'], shape: BoxShape.circle),
              ),
              Text(
                data['title'],
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
        );
      }).toList(),
    );
  }

  ///构建右边饼图
  buildRightPieChart() {
    return Container();
  }
}

class CustomShapePainter extends CustomPainter {
  List list;

  //画笔
  Paint _paint = Paint()..isAntiAlias = true;

  CustomShapePainter(this.list);

  @override
  void paint(Canvas canvas, Size size) {
    //中心
    Offset center = Offset(size.width / 2, size.height / 2);
    //半径取宽高一半 最小值
    double radius = min(size.width / 2, size.height / 2);
    //开始绘制的弧度
    double startRadian = -pi / 2;

    //总金额
    double total = 0.0;
    list.forEach((element) {
      total += element['number'];
    });

    //开始绘制
    for (var i = 0; i < list.length; i++) {
      //当前要绘制的选项
      var item = list[i];
      _paint.color = item['color'];

      //计算所占比例
      double radio = item['number'] / total;
      //计算弧度
      double sweepRadian = radio * 2 * pi;

      //开始绘制弧度
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
          startRadian, sweepRadian, true, _paint);

      //累加开始绘制的角度
      startRadian += sweepRadian;
    }
  }

  //刷新
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
