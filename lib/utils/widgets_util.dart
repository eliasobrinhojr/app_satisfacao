import 'package:flutter/material.dart';
import 'package:app_satisfacao/dao/info_dao.dart';

class WidgetsUtil {
  InfoDao infoDao = InfoDao();

  String filial = '', endereco = '', strInfo = '';

  WidgetsUtil() {
    infoDao.getInfo().then((value) {
      if (value.length > 0) {
        filial = value.first.filial;
        endereco = value.first.endereco + ', ' + value.first.numero;
        strInfo = 'Filial: $filial - $endereco';
      }
    });
  }

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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                child: Text(
                  "Pesquisa de Satisfação",
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0),
                child: Text(
                  strInfo,
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
            ],
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
