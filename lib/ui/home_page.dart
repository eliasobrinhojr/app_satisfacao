import 'dart:convert';
import 'dart:io';

import 'package:app_satisfacao/dao/config_dao.dart';
import 'package:app_satisfacao/dao/info_dao.dart';
import 'package:app_satisfacao/dao/tipo_dao.dart';
import 'package:app_satisfacao/model/config_model.dart';
import 'package:app_satisfacao/model/informacao_model.dart';
import 'package:app_satisfacao/model/tipo_model.dart';
import 'package:app_satisfacao/ui/pesquisa_page.dart';
import 'package:app_satisfacao/utils/widgets_util.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ConfigDao _configDao = ConfigDao();
  TipoDao _tipoDao = TipoDao();
  InfoDao _infoDao = InfoDao();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController ipTextController = TextEditingController();
  ConfigModel _configBean = ConfigModel();
  WidgetsUtil widUtil = WidgetsUtil();
  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    _configBean.itemAvaliado = "PMZ";
    BackButtonInterceptor.add(myInterceptor);
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    print("BACK BUTTON!"); // Do some stuff.
    return true;
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, ProgressDialogType.Normal);

    return Scaffold(
      appBar: widUtil.getAppbar(),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          margin: EdgeInsets.all(40.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0) //         <--- border radius here
                  )),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Satisfação PMZ',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff0E314A),
                              fontSize: 28.0),
                        ),
                      ),
                      Divider(),
                      TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "IP",
                              labelStyle: TextStyle(
                                  color: Color(0xff0E314A), fontSize: 18.0)),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(0xff0E314A), fontSize: 15.0),
                          controller: ipTextController,
                          validator: (value) {
                            if (value.isEmpty)
                              return "Insira um Endereço !";
                            else
                              _configBean.ip = value;
                          }),
                      Divider(
                        height: 25.0,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 50.0),
                        child: MaterialButton(
                          height: 80.0,
                          minWidth: 200.0,
                          color: Color(0xff0E314A),
                          textColor: Colors.white,
                          child: new Text(
                            "COMEÇAR",
                            style: TextStyle(fontSize: 20.0),
                          ),
                          onPressed: () {
                            actionStart();
                          },
                          splashColor: Colors.black,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  actionStart() {
    if (_formKey.currentState.validate()) {
      if (_configBean.itemAvaliado == null) {
        _ackAlert(context);
      } else {
        pr.setMessage('Conectando');
        pr.show();

        _configDao.saveConfig(_configBean).then((resp) async {
          if (await getTipos(resp.ip)) {
            _showPesquisaPage();
          } else {
            _infoDao.deleteAll();
            _configDao.deleteAll();
            Future.delayed(const Duration(milliseconds: 3000), () {
              pr.hide();
            });
          }
        }).catchError((err) {});
      }
    }
  }

  _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ATENÇÃO'),
          content: const Text('Selecione um item a ser avaliado !'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  getTipos(String ip) async {
    final String url = "http://" +
        ip +
        "/pmz/service-satisfacao/index.php/satisfacaoAvaliacao/tipoController/tipoOtimoInfoFilial";

    print("url: $url");
    var httpClient = new HttpClient();
    try {
      // Make the call
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var jsonObj = await response.transform(utf8.decoder).join();
        // Decode the json response
        var list = json.decode(jsonObj);

        for (var item in list['tipo_avaliacao']) {
          TipoModel tipo = TipoModel();
          tipo.idTipo = item['id_tipoavaliacao'];
          tipo.tipo = item['tipo'];
          tipo.descricao = item['descricao'];
          _tipoDao.saveTipo(tipo).then((r) {
            print('save');
          });
        }

        for (var item in list['informacao_filial']) {
          InformacaoModel info = InformacaoModel();
          info.filial = item['codigo'];
          info.endereco = item['endereco'];
          info.numero = item['ender_numero'];
          info.bairro = item['bairro'];
          _infoDao.saveInfo(info).then((r) {
            print('saveInfo');
          });
        }

        return true;
      } else {
        pr.update(message: "Falha na comunicação com o servidor");
        print("Failed http call.");
        return false;
      }
    } catch (exception) {
      pr.update(message: "Falha na comunicação com o servidor");
      print(exception.toString());
      return false;
    }
  }

  void _showPesquisaPage() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      Route route = MaterialPageRoute(builder: (context) => PesquisaPage());
      Navigator.pushReplacement(context, route);
    } else {
      SystemNavigator.pop();
    }
  }
}
