import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bilibili_learning/src/page/common/permission_request_widget.dart';
import 'package:permission_handler/permission_handler.dart';

///    author : jiangxk
///    e-mail : jxklongmao@gmai.com
///    date   : 2020/12/13 17:35
///    desc   :
///    version: 1.0
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> {
  List<String> _list = [
    "为您更好的体验应用，所以需要获取您的手机文件存储权限，以保存您的偏好设置",
    "您已拒绝权限，所以无法保存您的一些偏好设置，将无法使用APP",
    "您已拒绝权限，请在设置中心同意APP的权限请求",
    "其他错误"
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return PermissionRequestWidget(Permission.camera, _list);
          }));
    }).then((value) {
      if (value == null || !value) {
        //权限请求不通过

      } else {
        //权限请求通过
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("RootApp"),
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(children: [
              Text('Home'),
              GestureDetector(
                onTap: () {},
                child: Image.asset("assets/images/logo.png",
                    height: 100, width: 100),
              )
            ])));
  }
}
