
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_test/page/model/province.dart';
import 'package:weather_test/page/select/province_city_page.dart';
import 'package:weather_test/utils/adapter.dart';

class ProvinceSelectPage extends StatefulWidget {
  @override
  _ProvinceSelectPageState createState() => _ProvinceSelectPageState();
}

class _ProvinceSelectPageState extends State<ProvinceSelectPage> {
  List<Province> provinceList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '省份',
          style: TextStyle(
            fontSize: ScreenAdapter.getFontSize(25),
          ),
        ),
      ),
      body: FutureBuilder(
        future: Dio().get("http://guolin.tech/api/china"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Response response = snapshot.data;
            //发生错误
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            provinceList = getProvinceList(response.data);
            //请求成功，通过项目信息构建用于显示项目名称的ListView
            return ListView.builder(
              itemCount: provinceList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: ListTile(
                    title: Text("${provinceList[index].name}"),
                  ),
                  onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                          return ProvinceCityPage(
                            provinceID: provinceList[index].id,
                          );
                      }));
                  },
                );
              },
            );
          }
          // 请求未完成时弹出loading
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
