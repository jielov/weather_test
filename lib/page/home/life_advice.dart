import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_test/page/model/lifestyle_weather.dart';
import 'package:weather_test/res/dimens.dart';
import 'package:weather_test/utils/adapter.dart';

class LifeAdvice extends StatefulWidget {
  final cityID;
  final appKey;

  const LifeAdvice({Key key, this.cityID, this.appKey}) : super(key: key);

  @override
  _LifeAdviceState createState() => _LifeAdviceState();
}

class _LifeAdviceState extends State<LifeAdvice> {
  List<String> _lifestyleWeatherBrf = [
    "较舒适",
    "较舒适",
    "适宜",
    "适宜",
    "弱",
    "较适宜",
    "中"
  ];
  List<String> _lifestyleWeatherTxt = [
    "白天天气晴好，早晚会感觉偏凉，午后舒适、宜人。",
    "建议着薄外套、开衫牛仔衫裤等服装。年老体弱者应适当添加衣物，宜着夹克衫、薄毛衣等。",
    "各项气象条件适宜，无明显降温过程，发生感冒机率较低。",
    "天气较好，赶快投身大自然参与户外运动，尽情感受运动的快乐吧。",
    "天气较好，但丝毫不会影响您出行的心情。温度适宜又有微风相伴，适宜旅游。",
    "紫外线强度较弱，建议出门前涂擦SPF在12-15之间、PA+的防晒护肤品。",
    "较适宜洗车，未来一天无雨，风力较小，擦洗一新的汽车至少能保持一天。",
    ",气象条件对空气污染物稀释、扩散和清除无明显影响，易感人群应适当减少室外活动时间。"
  ];

  String _cityID;
  String _key;
  LifestyleWeather _lifestyleWeather;

  @override
  void initState() {
    // TODO: implement initState
    _cityID = widget.cityID;
    _key = widget.appKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              '生活建议',
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenAdapter.getFontSize(20),
              ),
            ),
          ),
          FutureBuilder(
              future: Dio().get(
                  "https://free-api.heweather.net/s6/weather/lifestyle?location=$_cityID&key=$_key"),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Response response = snapshot.data;
                  //发生错误
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  _lifestyleWeather = LifestyleWeather.fromJson(response.data);
                  //请求成功，通过项目信息构建用于显示项目名称的ListView
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _lifestyleWeather.heWeather6[0].lifestyle.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${_lifestyleWeather.heWeather6[0].lifestyle[index].brf}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenAdapter.getFontSize(14),
                              ),
                            ),
                            Text(
                              "${_lifestyleWeather.heWeather6[0].lifestyle[index].txt}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenAdapter.getFontSize(14),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
                return CircularProgressIndicator();
              }),
        ],
      ),
    );
  }
}
