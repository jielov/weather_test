import 'package:flutter/material.dart';
import 'package:weather_test/utils/adapter.dart';

import 'start_page.dart';

class MyRootPage extends StatefulWidget {
  @override
  _MyRootPageState createState() => _MyRootPageState();
}

class _MyRootPageState extends State<MyRootPage> {
  @override
  Widget build(BuildContext context) {
    ///初始化ScreenUtil
    ScreenAdapter.setDesignWHs(context, 375, 667, allowFontScaling: true);
    return StartPage();
  }
}
