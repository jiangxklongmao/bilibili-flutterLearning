import 'dart:math';

import 'package:flutter/material.dart';

class SnowPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SnowPageState();
  }
}

class _SnowPageState extends State<SnowPage> with TickerProviderStateMixin {
  List<CustomPoint> _list = [];

  Random _random = Random();

  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    //初始化动画控制器 重复执行
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 5))
          ..addListener(() {
            setState(() {});
          })
          ..repeat();

    //创建雪花点

    Future.delayed(Duration.zero, () {
      for (int i = 0; i < 200; i++) {
        //创建点
        CustomPoint point = new CustomPoint();

        double x = _random.nextDouble() * MediaQuery.of(context).size.width;
        double y = _random.nextDouble() * MediaQuery.of(context).size.height;
        point
          ..position = Offset(x, y)
          ..origin = Offset(x, y);

        if (i % 3 == 0) {
          point.radius = _random.nextDouble() * 2 + 2;
          point.speed = _random.nextDouble() + 0.5;
        } else {
          point.radius = _random.nextDouble() * 1 + 1;
          point.speed = _random.nextDouble() + 0.1;
        }

        _list.add(point);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //填充布局
      body: Container(
        width: double.infinity,
        height: double.infinity,
        //层叠布局
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1606559665664&di=e907b7170d5474182f4c10693b1b4a6f&imgtype=0&src=http%3A%2F%2Fpic.vjshi.com%2F2020-01-12%2Fd2584e9710469221b122831e45c801e1%2F00003.jpg%3Fx-oss-process%3Dstyle%2Fwatermark",
                fit: BoxFit.cover),
            Positioned.fill(
                child: CustomPaint(
              painter: ShowCustomPainter(list: _list),
            )),
            // Text(
            //   "Hello world",
            //   style: TextStyle(
            //       fontSize: 33,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.yellow),
            // )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

//绘制雪花效果
class ShowCustomPainter extends CustomPainter {
  //画笔抗锯齿白色
  Paint _paint = new Paint()
    ..isAntiAlias = true
    ..color = Colors.white;

  //点的集合
  List<CustomPoint> list;

  Random _random = Random();

  ShowCustomPainter({@required this.list});

  //绘制操作
  @override
  void paint(Canvas canvas, Size size) {
    //在每次绘制前计算一下坐标
    list.forEach((element) {
      double x = element.position.dx;
      double y = element.position.dy;

      if (y >= size.height) {
        y = 0;
        x = element.origin.dx;
      }

      double offsetX = 0.0;
      if (element.speed < 1) {
        offsetX = sin(y / size.height * 2 * pi) / 2;
      }

      element.position = Offset(x + offsetX, y + element.speed);
    });

    list.forEach((element) {
      //绘制点集合
      canvas.drawCircle(element.position, element.radius, _paint);
    });
  }

  //实时刷新
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CustomPoint {
  //点的位置
  Offset position;

  //点  初始化的位置 移动出后需要重新初始化
  Offset origin;

  //大小
  double radius;

  //移动速度
  double speed;
}
