import 'dart:math';

import 'package:flutter/material.dart';

///    author : jiangxk
///    e-mail : jxklongmao@gmai.com
///    date   : 2020/12/6 14:30
///    desc   : 波浪登录页面
///    version: 1.0
class WaveLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WaveLoginPageState();
  }
}

class WaveLoginPageState extends State<WaveLoginPage>
    with SingleTickerProviderStateMixin {
  //设置头背景颜色值数组
  List<Color> _colorList = [Color(0xFFE0647B), Color(0xFFFCDD89)];

  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 5),
        //定义动画控制的变化范围
        lowerBound: -1.0,
        upperBound: 1.0,
        value: 0.0);
    _animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //填充布局
      body: Container(
        //填充
        width: double.infinity,
        height: double.infinity,
        //层叠 布局
        child: Stack(
          children: [
            AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return ClipPath(
                    //定义裁剪的路径
                    clipper: CustomHeaderClipPath(_animationController.value),
                    //裁剪的内容
                    child: buildContainer(context),
                  );
                }),
          ],
        ),
      ),
    );
  }

  ///生成填充
  Container buildContainer(BuildContext context) {
    return Container(
      //高度
      //MediaQuery.of(context).size.height 当前视图的高度
      height: MediaQuery.of(context).size.height * 0.45,
      decoration: BoxDecoration(
          //设置一个渐变样式的背景
          gradient: LinearGradient(
              colors: _colorList,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
    );
  }
}

///region 自定义裁剪路径
class CustomHeaderClipPath extends CustomClipper<Path> {
  //定义进度
  double progress;

  CustomHeaderClipPath(this.progress);

  ///定义裁剪规则
  @override
  getClip(Size size) {
    //构建Path
    Path path = Path();
    //移动到初始点 并连线
    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.8);

    //动态生成控制点
    double controllerCenterX =
        size.width * 0.5 + (size.width * 0.6 + 1) * sin(progress * pi);
    double controllerCenterY = size.height * 0.8 + 70 * cos(progress * pi);

    //构建二阶贝塞尔曲线
    path.quadraticBezierTo(
        //控制点
        controllerCenterX,
        controllerCenterY,
        //结束点
        size.width,
        size.height * 0.8);

    path.lineTo(size.width, 0);

    return path;
  }

  ///是否自动刷新
  @override
  bool shouldReclip(covariant CustomClipper<dynamic> oldClipper) {
    return true;
  }
}

///endregion
