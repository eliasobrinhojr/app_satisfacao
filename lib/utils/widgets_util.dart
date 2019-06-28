import 'package:flutter/material.dart';

class WidgetsUtil {
  Widget getAppbar() {
    var assets = new AssetImage('lib/assets/ic_lojas.png');
    var image = new Image(image: assets, width: 130.0, height: 130.0);

    return AppBar(
      title: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
            child: new Container(
              child: image,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
            child: Text(
              "Pesquisa de Satisfação",
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xff0E314A),
      centerTitle: false,
      bottom: PreferredSize(
          preferredSize: Size(10.0, 10.0),
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
