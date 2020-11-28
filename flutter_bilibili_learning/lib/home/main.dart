import 'package:flutter/material.dart';
import 'package:flutter_bilibili_learning/page/SnowPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      routes: {"snow": (BuildContext context) => SnowPage()},
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Learning')),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [_createItem("雪花效果", "snow")],
        ),
      ),
    );
  }

  Widget _createItem(String pageName, String routeName) {
    return Container(
      margin: EdgeInsets.all(20),
      width: 200,
      child: RaisedButton(
        onPressed: () {
          Navigator.pushNamed(context, routeName);
          // Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
        child: Text(
          pageName,
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
      ),
    );
  }
}
