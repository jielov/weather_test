import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flukit/flukit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quiver/strings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather_test/page/model/splash_model.dart';
import 'package:weather_test/res/app_color.dart';
import 'package:weather_test/utils/adapter.dart';
import 'package:weather_test/utils/navigator_util.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  List<String> _guideList = [
    "assets/images/start_01.jpg",
    "assets/images/start_02.jpg",
    "assets/images/start_03.jpg",
    "assets/images/start_04.jpg",
  ];

  List<Widget> _bannerList = List();
  Timer _timer;
  int _status = 0; // 0-启动图，1-广告图和倒计时跳过，2-引导图
  int _count = 3; // 倒计时秒数

  SplashModel _splashModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initGuideBanner();
  }

  _initGuideBanner() {
    setState(() {
      _status = 2;
    });
    for (int i = 0, lenget = _guideList.length; i < lenget; i++) {
      if (i == lenget - 1) {
        _bannerList.add(Stack(
          children: <Widget>[
            Image.asset(
              _guideList[i],
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(
                  bottom: ScreenAdapter.getWidth(160),
                ),
                child: InkWell(
                  onTap: () {
                    _goMain();
                  },
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.indigoAccent,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "立即体验",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenAdapter.getFontSize(16),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
      } else {
        _bannerList.add(Image.asset(
          _guideList[i],
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ));
      }
    }
  }

  _initSplash() {
    if (_splashModel == null) {
      _goMain();
      return;
    }
    setState(() {
      _status = 1;
    });

    ///倒计时
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_count <= 1) {
          _timer.cancel();
          _timer = null;
          _goMain();
        } else {
          _count = _count - 1;
        }
      });
    });
  }

  //跳转主页
  void _goMain() {
    NavigatorUtil.naSkipPage(context);
  }

  ///构建闪屏背景
  Widget _buildSplashBg() {
    return Image.asset(
      "assets/images/start_01.jpg",
      fit: BoxFit.fill,
      width: double.infinity,
      height: double.infinity,
    );
  }

  //构建广告
  Widget _buildAdWidget() {
    if (_splashModel == null) {
      return Container(
        height: 0,
      );
    }
    return Offstage(
      offstage: !(_status == 1),
      child: InkWell(
        onTap: () async {
          String url = _splashModel.url;
          if (isEmpty(url)) return;
          _goMain();
          if (url.endsWith(".apk")) {
            await launch(url, forceSafariVC: false, forceWebView: false);
          } else {
            // 在浏览器中打开url
//            Application.router.navigateTo(
//                context,
//                Routers.adPage +
//                    '?title=${Uri.encodeComponent(_splashModel.title)}&url=${Uri.encodeComponent(_splashModel.url)}',
//                transition: TransitionType.fadeIn);
          }
        },
        child: Container(
          alignment: Alignment.center,
          child: CachedNetworkImage(
            imageUrl: _splashModel.imgUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
            placeholder: (context, url) => _buildSplashBg(),
            errorWidget: (context, url, error) => _buildSplashBg(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: Stack(
        children: <Widget>[
          Offstage(
            offstage: !(_status == 0),
            child: _buildSplashBg(),
          ),
          Offstage(
            offstage: !(_status == 2),
            child: _bannerList.isEmpty
                ? Container()
                : Swiper(
                    autoStart: false,
                    circular: false,
                    indicator: CircleSwiperIndicator(
                      radius: 4,
                      padding: EdgeInsets.only(
                        bottom: ScreenAdapter.getWidth(30),
                      ),
                      itemColor: Colors.black26,
                    ),
                    children: _bannerList,
                  ),
          ),
          _buildAdWidget(),
          Offstage(
            offstage: !(_status == 1),
            child: Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.all(20),
              child: InkWell(
                onTap: () {
                  _goMain();
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    '$_count 跳转',
                    style: TextStyle(
                      fontSize: ScreenAdapter.getFontSize(14),
                      color: Colors.white,
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: AppColor.color_660000,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      border: Border.all(
                        width: ScreenAdapter.getWidth(0.33),
                        color: Colors.grey,
                      )),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
