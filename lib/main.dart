import 'package:app_satisfacao/ui/splash_page.dart';
import 'package:app_satisfacao/ui/home_page.dart';
import 'package:app_satisfacao/ui/pesquisa_page.dart';
import 'package:flutter/material.dart';
import 'package:app_satisfacao/dao/config_dao.dart';

void main() {
  ConfigDao _cfgDao = ConfigDao();

  var home;

  _cfgDao.getConfig().then((result) {

    if (result == null) {
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
