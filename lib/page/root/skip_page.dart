import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_test/page/home/home_page.dart';
import 'package:weather_test/page/select/province_select_page.dart';
import 'package:weather_test/utils/adapter.dart';

class SkipPage extends StatefulWidget {
  @override
  _SkipPageState createState() => _SkipPageState();
}

class _SkipPageState extends State<SkipPage> {
  String _cityID;

  @override
  void initState() {
    // 从文件读取ID
    _readCounter();
    super.initState();
  }

  void _readCounter() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String cityID = preferences.getString("cityID");
    setState(() {
      _cityID = cityID;
    });
  }

  @override
  Widget build(BuildContext context) {
    ///初始化ScreenUtil
    ScreenAdapter.setDesignWHs(context, 375, 667, allowFontScaling: true);
    return _cityID == null
        ? ProvinceSelectPage()
        : HomePage(
            cityID: _cityID,
          );
  }
}
