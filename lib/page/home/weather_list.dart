
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weather_test/page/model/forecast_weather.dart';
import 'package:weather_test/res/dimens.dart';
import 'package:weather_test/utils/adapter.dart';

class weatherList extends StatefulWidget {
  final cityID;
  final appKey;

  const weatherList({Key key, this.cityID, this.appKey}) : super(key: key);

  @override
  _weatherListState createState() => _weatherListState();
}

class _weatherListState extends State<weatherList> {
  List<String> dates = ["2019/10/01", "2019/10/02", "2019/10/03"];
  List<String> temperatures = ["29/14", "30/18", "29/18"];
  List<String> texts = ["阴", "晴", "雨"];
  String _cityID;
  String _key;
  ForecastWeather _forecastWeather;

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
              '预报',
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenAdapter.getFontSize(20),
              ),
            ),
          ),
          FutureBuilder(
              future: Dio().get(
                  "https://free-api.heweather.net/s6/weather/forecast?location=$_cityID&key=$_key"),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Response response = snapshot.data;
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  _forecastWeather = ForecastWeather.fromJson(response.data);
                  //请求成功，通过项目信息构建用于显示项目名称的ListView
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:
                        _forecastWeather.heWeather6[0].dailyForecast.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Text(
                              "${_forecastWeather.heWeather6[0].dailyForecast[index].date}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenAdapter.getFontSize(14)),
                            ),
                            Text(
                              "${_forecastWeather.heWeather6[0].dailyForecast[index].condTxtD}/${_forecastWeather.heWeather6[0].dailyForecast[index].condCodeN}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenAdapter.getFontSize(14),
                              ),
                            ),
                            Text(
                              "${_forecastWeather.heWeather6[0].dailyForecast[index].tmpMax}/${_forecastWeather.heWeather6[0].dailyForecast[index].tmpMin}",
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
              })
        ],
      ),
    );
  }
}
