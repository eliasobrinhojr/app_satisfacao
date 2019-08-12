import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var assets = new AssetImage('lib/assets/ic_splash.png');
    var image = new Image(image: assets, width: 400.0, height: 180.0);

    return Container(
      color: Color(0xff0E314A),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: image,
            ),
            new DotsIndicator(dotsCount: 5, position: 3)
          ],
        ),
      ),
    );
  }
}
