import 'dart:math';

import 'package:flutter/material.dart';

///    author : jiangxk
///    e-mail : jxklongmao@gmai.com
///    date   : 2020/11/28 17:45
///    desc   : 气泡登录页面
///    version: 1.0
class BubbleLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BubbleLoginPageState();
  }
}

class _BubbleLoginPageState extends State<BubbleLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            //第一部分 渐变背景
            buildBackground(),
            //第二部分 气泡动画
            buildBobbleWidget(),
            //第三部分 高斯模糊
            //第四部分 输入区域
          ],
        ),
      ),
    );
  }

  ///构建背景Widget
  buildBackground() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              //渐变方向
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              //渐变色值
              colors: [
            Colors.lightBlueAccent.withOpacity(0.5),
            Colors.lightBlue.withOpacity(0.5),
            Colors.blue.withOpacity(0.5)
          ])),
    );
  }

  ///构建气泡Widget
  buildBobbleWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: _BubbleWidget(),
    );
  }
}

///气泡Widget
class _BubbleWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BubbleState();
  }
}

class _BubbleState extends State<_BubbleWidget> with TickerProviderStateMixin {
  //气泡集合
  List<BobbleBean> _list = [];

  //速度最大值
  double _maxSpeed = 1.0;

  //半径最大值
  double _maxRadius = 80;

  //角度最大值
  double _maxTheta = 2 * pi;

  //动画控制器
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    var _random = Random(DateTime.now().microsecondsSinceEpoch);
    for (int i = 0; i < 20; i++) {
      BobbleBean bobble = BobbleBean()
        //位置默认值
        ..location = Offset(-1, -1)
        ..color = getRandomAlphaWhiteColor(_random)
        ..speed = _random.nextDouble() * _maxSpeed
        ..radius = _random.nextDouble() * _maxRadius
        ..theta = _random.nextDouble() * _maxTheta;
      _list.add(bobble);
    }

    //动画控制器初始化
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..addListener(() {
            setState(() {});
          });
    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: CustomPaint(
      size: MediaQuery.of(context).size,
      //画布
      painter: CustomBobblePainter(list: _list),
    ));
  }

  ///获取随机透明度的白色
  Color getRandomAlphaWhiteColor(Random random) {
    int alpha = random.nextInt(200);
    return Color.fromARGB(alpha, 255, 255, 255);
  }
}

///自定义气泡
class CustomBobblePainter extends CustomPainter {
  List<BobbleBean> list;

  Paint _paint = Paint()..isAntiAlias = true;

  CustomBobblePainter({@required this.list});

  var _random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    //根据气泡的速度与角度 计算每次便宜后的新坐标中心
    list.forEach((element) {
      Offset newCenterOffset = calculateXY(element.speed, element.theta);

      double dx = newCenterOffset.dx + element.location.dx;
      double dy = newCenterOffset.dy + element.location.dy;

      //计算边界
      if (dx < 0 || dx > size.width) {
        dx = _random.nextDouble() * size.width;
      }

      if (dy < 0 || dy > size.height) {
        dy = _random.nextDouble() * size.height;
      }
      element.location = Offset(dx, dy);
    });

    list.forEach((element) {
      //根据气泡修改画笔颜色
      _paint.color = element.color;
      //绘制气泡
      canvas.drawCircle(element.location, element.radius, _paint);
    });
  }

  ///刷新控制
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    //返回false 不刷新
    return true;
  }

  ///根据速度和角度计算偏移量
  Offset calculateXY(double speed, double theta) {
    return Offset(speed * cos(theta), speed * sin(theta));
  }
}

//气泡模型
class BobbleBean {
  //位置
  Offset location;

  //颜色
  Color color;

  //运动的速度
  double speed;

  //运动的角度
  double theta;

  //气泡大小
  double radius;
}
