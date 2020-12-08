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

class PieChartState extends State<PieChartWidget>
    with SingleTickerProviderStateMixin {
  Color mainColor = Color(0xFFE3E2ED);
  List _list = [
    {'title': '生活费', 'number': 200, 'color': Colors.blue},
    {'title': '交通费', 'number': 300, 'color': Colors.yellow},
    {'title': '贷款费', 'number': 500, 'color': Colors.red},
    {'title': '游玩费', 'number': 200, 'color': Colors.orange},
    {'title': '通讯费', 'number': 100, 'color': Colors.deepPurple}
  ];

  //动画控制器
  AnimationController _animationController;

  //控制动画背景抬高
  Animation<double> _bgAnimation;

  //控制饼图
  Animation<double> _progressAnimation;

  //控制数字使用
  Animation<double> _numberAnimation;

  @override
  void initState() {
    super.initState();
    //初始化动画监听
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _bgAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController,
        //执行时间 区间
        curve: Interval(0.0, 0.5, curve: Curves.elasticOut)));
    _progressAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController,
        //执行时间 区间
        curve: Interval(0.4, 0.8, curve: Curves.elasticOut)));
    _numberAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController,
        //执行时间 区间
        curve: Interval(0.7, 1.0, curve: Curves.elasticOut)));
    _animationController.addListener(() {
      setState(() {});
    });
  }

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
        onPressed: () {
          _animationController.reset();
          _animationController.forward();
        },
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
              //子Widget居中
              alignment: Alignment.center,
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
                            spreadRadius: -8 * _bgAnimation.value,
                            //阴影偏移量
                            offset: Offset(-5 * _bgAnimation.value,
                                -5 * _bgAnimation.value),
                            //模糊度
                            blurRadius: 30 * _bgAnimation.value),
                        BoxShadow(
                            color: Colors.blue[300],
                            spreadRadius: 2 * _bgAnimation.value,
                            offset: Offset(
                                5 * _bgAnimation.value, 5 * _bgAnimation.value),
                            blurRadius: 20 * _bgAnimation.value)
                      ]),
                  child: CustomPaint(
                    size: Size(200, 200),
                    painter:
                        CustomShapePainter(_list, _progressAnimation.value),
                  ),
                ),
                //第二层
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                      color: mainColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            //阴影颜色
                            color: Colors.grey.withOpacity(0.7),
                            //模糊半径
                            spreadRadius: 1 * _numberAnimation.value,
                            //模糊度
                            blurRadius: 5 * _numberAnimation.value,
                            //阴影偏移量
                            offset: Offset(5 * _numberAnimation.value,
                                5 * _numberAnimation.value))
                      ]),
                  child: Center(
                    child: Text(
                      '￥100',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 22),
                    ),
                  ),
                )
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
          //设置水平 垂直Padding
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

  double progress;

  CustomShapePainter(this.list, this.progress);

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
      double sweepRadian = radio * 2 * pi * progress;

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
