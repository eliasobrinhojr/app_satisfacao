import 'package:flutter/material.dart';

class WidgetsUtil {
  Widget getAppbar() {
    var assets = new AssetImage('lib/assets/ic_appbar.png');
    var image = new Image(image: assets, width: 100.0, height: 100.0);

    return AppBar(
      title: Row(
        children: <Widget>[
          new Container(
            child: image,
          ),
          Text(
            "Pesquisa de Satisfação",
          )
        ],
      ),
      backgroundColor: Color(0xff0E314A),
      centerTitle: false,
      bottom: PreferredSize(
          preferredSize: Size(0.0, 0.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xffE14422), width: 3.0),
              ),
            ),
          )),
    );
  }
}
