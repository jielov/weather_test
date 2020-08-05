import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_test/page/home/weather_list.dart';
import 'package:weather_test/page/model/now_weather.dart';
import 'package:weather_test/page/select/province_select_page.dart';
import 'package:weather_test/res/dimens.dart';
import 'package:weather_test/utils/adapter.dart';

import 'life_advice.dart';

class HomePage extends StatefulWidget {
  final String cityID;

  const HomePage({Key key, this.cityID}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _cityID;
  NowWeather _nowWeather;
  final String key = "cd09fcf733ee429aade1d41b467e1c1f";

  @override
  void initState() {
    _cityID = widget.cityID;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
                "http://pic.sc.chinaz.com/files/pic/pic9/202007/apic26854.jpg"),
            fit: BoxFit.cover),
      ),
      child: _weatherBody(),
    );
  }

  Widget _weatherBody() {
    return FutureBuilder(
      future: Dio().get(
          "https://free-api.heweather.net/s6/weather/now?location=$_cityID&key=$key"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Response response = snapshot.data;
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          _nowWeather = NowWeather.fromJson(response.data);
          //请求成功，通过项目信息构建用于显示项目名称的ListView
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              leading: GestureDetector(
                child: Icon(Icons.home),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProvinceSelectPage();
                  }));
                },
              ),
              title: Text(
                "${_nowWeather.heWeather6[0].basic.location}",
                style: TextStyle(fontSize: ScreenAdapter.getFontSize(25)),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              actions: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text(
                    "${_nowWeather.heWeather6[0].update.loc}",
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            body: _nowWeather == null
                ? Text("正在加载")
                : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${_nowWeather.heWeather6[0].now.tmp}°C",
                            style: TextStyle(
                              fontSize: ScreenAdapter.getFontSize(50),
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${_nowWeather.heWeather6[0].now.condTxt}',
                            style: TextStyle(
                              fontSize: ScreenAdapter.getFontSize(20),
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: Dimens.marginLeft,
                              right: Dimens.marginRight,
                              top: ScreenAdapter.getHeight(10),
                              bottom: ScreenAdapter.getHeight(15)),
                          child: Container(
                            color: Colors.black54,
                            child: weatherList(
                              appKey: key,
                              cityID: _cityID,
                            ), //3天天气预报
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: Dimens.marginLeft,
                            right: Dimens.marginRight,
                          ),
                          child: Container(
                            color: Colors.black54,
                            child: _atmosphereList(), // 空气质量
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: ScreenAdapter.getHeight(15),
                            left: Dimens.marginLeft,
                            right: Dimens.marginRight,
                            bottom: ScreenAdapter.getHeight(15),
                          ),
                          child: Container(
                            color: Colors.black54,
                            child: LifeAdvice(
                              appKey: key,
                              cityID: _cityID,
                            ), //生活建议
                          ),
                        )
                      ],
                    ),
                  ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget _atmosphereList() {
    return Container(
      padding: EdgeInsets.only(
        top: ScreenAdapter.getHeight(10),
        left: Dimens.marginLeft,
        right: Dimens.marginRight,
      ),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "空气质量",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
          GridView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, //横轴三个子widget
                childAspectRatio: 2 //显示区域宽高相等
                ),
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "${_nowWeather.heWeather6[0].now.vis}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                    ),
                  ),
                  Text(
                    "能见度",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    "${_nowWeather.heWeather6[0].now.hum}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                    ),
                  ),
                  Text(
                    "湿度",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
