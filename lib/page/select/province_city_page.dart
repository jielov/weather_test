import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_test/page/model/city.dart';
import 'package:weather_test/page/select/province_county_page.dart';
import 'package:weather_test/utils/adapter.dart';

class ProvinceCityPage extends StatefulWidget {
  final int provinceID;

  const ProvinceCityPage({Key key, this.provinceID}) : super(key: key);

  @override
  _ProvinceCityPageState createState() => _ProvinceCityPageState();
}

class _ProvinceCityPageState extends State<ProvinceCityPage> {
  int _provinceID;
  List<City> _cityList;

  @override
  void initState() {
    // TODO: implement initState
    _provinceID = widget.provinceID;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '城市',
          style: TextStyle(
            fontSize: ScreenAdapter.getFontSize(25),
          ),
        ),
      ),
      body: FutureBuilder(
          future: Dio().get("http://guolin.tech/api/china/$_provinceID"),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Response response = snapshot.data;
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              _cityList = getCityList(response.data);
              return ListView.builder(
                  itemCount: _cityList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: ListTile(
                        title: Text("${_cityList[index].name}"),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ProvinceCountyPage(
                            provinceID: _provinceID,
                            cityID: _cityList[index].id,
                          );
                        }));
                      },
                    );
                  });
            }
            return CircularProgressIndicator();
          }),
    );
  }
}
