import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_test/page/home/home_page.dart';
import 'package:weather_test/page/model/county.dart';
import 'package:weather_test/utils/adapter.dart';

class ProvinceCountyPage extends StatefulWidget {
  final int provinceID;
  final int cityID;

  const ProvinceCountyPage({
    Key key,
    this.provinceID,
    this.cityID,
  }) : super(key: key);

  @override
  _ProvinceCountyPageState createState() => _ProvinceCountyPageState();
}

class _ProvinceCountyPageState extends State<ProvinceCountyPage> {
  int _provinceID;
  int _cityID;
  List<County> _county;

  @override
  void initState() {
    // TODO: implement initState
    _provinceID = widget.provinceID;
    _cityID = widget.cityID;
    super.initState();
  }

  void _saveCityID(String cityID) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("cityID", cityID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '区县',
          style: TextStyle(
            fontSize: ScreenAdapter.getFontSize(25),
          ),
        ),
      ),
      body: FutureBuilder(
          future:
              Dio().get("http://guolin.tech/api/china/$_provinceID/$_cityID"),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Response response = snapshot.data;
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              _county = getCountyList(response.data);
              return ListView.builder(
                  itemCount: _county.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: ListTile(
                        title: Text("${_county[index].name}"),
                      ),
                      onTap: () {
                        _saveCityID(_county[index].weatherId);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return HomePage(
                            cityID: _county[index].weatherId,
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
