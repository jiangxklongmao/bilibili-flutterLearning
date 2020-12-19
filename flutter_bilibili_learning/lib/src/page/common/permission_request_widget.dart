import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

///    author : jiangxk
///    e-mail : jxklongmao@gmai.com
///    date   : 12/16/20 21:16
///    desc   :
///    version: 1.0
class PermissionRequestWidget extends StatefulWidget {
  final Permission permission;
  final List<String> permissionList;
  final bool isCloseApp;
  final String leftButtonText;

  PermissionRequestWidget(this.permission, this.permissionList,
      {this.isCloseApp = true, this.leftButtonText = "退出"});

  @override
  State<StatefulWidget> createState() {
    return PermissionRequestState();
  }
}

class PermissionRequestState extends State<PermissionRequestWidget>
    with WidgetsBindingObserver {
  bool _isGoSetting = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();

    //注册APP生命周期切换
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && _isGoSetting) {
      _checkPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
    );
  }

  ///检查权限
  void _checkPermission({PermissionStatus status}) async {
    //权限
    Permission permission = widget.permission;

    //权限状态
    if (status == null) {
      status = await permission.status;
    }

    if (status.isUndetermined) {
      //待定 第一次申请
      showPermissionAlert(permission, widget.permissionList[0], "同意");
    } else if (status.isDenied) {
      //拒绝 第一次申请拒绝
      if (Platform.isIOS) {
        //永久拒绝
        showPermissionAlert(permission, widget.permissionList[2], "去设置中心",
            isSetting: true);
        return;
      }
      showPermissionAlert(permission, widget.permissionList[1], "重试");
    } else if (status.isPermanentlyDenied) {
      //永久拒绝
      showPermissionAlert(permission, widget.permissionList[2], "去设置中心",
          isSetting: true);
    } else {
      //获得权限
      Navigator.of(context).pop(true);
    }
  }

  ///显示权限弹窗
  void showPermissionAlert(
      Permission permission, String message, String rightButton,
      {bool isSetting: false}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("权限申请"),
            actions: [
              RaisedButton(
                onPressed: () {
                  if (widget.isCloseApp) {
                    exitApp();
                  } else {
                    Navigator.of(context).pop(false);
                  }
                },
                child: Text('${widget.leftButtonText}'),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (isSetting) {
                    _isGoSetting = true;
                    openAppSettings();
                    return;
                  }
                  //申请权限
                  _requestPermission(permission);
                },
                child: Text('$rightButton'),
              )
            ],
          );
        });
  }

  ///申请权限
  void _requestPermission(Permission permission) async {
    //发起权限申请
    PermissionStatus status = await permission.request();
    _checkPermission(status: status);
  }

  ///退出应用
  void exitApp() {
    SystemChannels.platform.invokeMethod("SystemNavigator.pop");
  }
}
