import 'package:app_satisfacao/ui/splash_page.dart';
import 'package:app_satisfacao/ui/home_page.dart';
import 'package:app_satisfacao/ui/pesquisa_page.dart';
import 'package:flutter/material.dart';
import 'package:app_satisfacao/dao/config_dao.dart';
import 'package:flutter/services.dart';

void main() {
  ConfigDao _cfgDao = ConfigDao();

  var home;

  _cfgDao.getConfig().then((result) {

    if (result == null) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      home = HomePage();
    } else {

      home = PesquisaPage();
    }

   // home = SplashPage();

    runApp(MaterialApp(
      home: home,
      debugShowCheckedModeBanner: false,
    ));
  });
}
