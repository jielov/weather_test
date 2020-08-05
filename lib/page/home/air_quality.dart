import 'package:flutter/material.dart';
import 'package:weather_test/res/dimens.dart';
import 'package:weather_test/utils/adapter.dart';

class AirQuality extends StatefulWidget {
  final cityID;
  final appKey;

  const AirQuality({Key key, this.cityID, this.appKey}) : super(key: key);

  @override
  _AirQualityState createState() => _AirQualityState();
}

class _AirQualityState extends State<AirQuality> {
  List<String> atmospheres = ["16", "56"];
  List<String> humidityLIst = ["能见度", "湿度"];
  String _cityID;
  String _key;

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
              '空气质量',
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenAdapter.getFontSize(20),
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //横轴三个子widget
              childAspectRatio: 2, //显示区域宽高相等
            ),
            itemCount: atmospheres.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  Text(
                    '${atmospheres[index]}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenAdapter.getFontSize(40)),
                  ),
                  Text(
                    '${humidityLIst[index]}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenAdapter.getFontSize(20),
                    ),
                  )
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
