import 'dart:async';
import 'dart:convert';

import 'package:app_satisfacao/dao/config_dao.dart';
import 'package:app_satisfacao/model/avaliacao_model.dart';
import 'package:app_satisfacao/model/config_model.dart';
import 'package:app_satisfacao/ui/concluido_page.dart';
import 'package:app_satisfacao/utils/widgets_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ExperienciaPage extends StatefulWidget {
  var _tipoAvaliacao;

  ExperienciaPage(this._tipoAvaliacao);

  @override
  _ExperienciaPageState createState() => _ExperienciaPageState(_tipoAvaliacao);
}

class _ExperienciaPageState extends State<ExperienciaPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _tipoAvaliacao;

  _ExperienciaPageState(this._tipoAvaliacao);

  WidgetsUtil widUtil = WidgetsUtil();

  ConfigDao _cfgDao = ConfigDao();
  ConfigModel cfgBean = ConfigModel();

  AvaliacaoModel avaliacaoBean = AvaliacaoModel();

  bool pressed = false;
  String _item = '';

  @override
  void initState() {
    super.initState();
    _getConfig();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    var label = cfgBean.itemAvaliado;

    return Scaffold(
      appBar: widUtil.getAppbar(),
      backgroundColor: Colors.white,
      body: FutureBuilder<String>(
          future: getData(cfgBean.ip),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              //   return new Container();
//                return Center(
//                  child: Text('Carregando Dados..',
//                      style:
//                      TextStyle(color: Color(0xff0E314A), fontSize: 25.0),
//                      textAlign: TextAlign.center),
//                );
              default:
                if (snapshot.hasError) {
                  // return new Container();
                  return Center(
                    child: Text(
                        'Erro ao Carregar Dados\n verificar {$cfgBean.ip}',
                        style:
                            TextStyle(color: Color(0xff0E314A), fontSize: 25.0),
                        textAlign: TextAlign.center),
                  );
                } else {
                  if (snapshot.data != null) {
                    List<dynamic> lista = json.decode(snapshot.data);
                    List<dynamic> coluna1 = List(), coluna2 = List();

                    lista.asMap().forEach((i, value) => i < 3 ? coluna1.add(value) : coluna2.add(value));

                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(32.0, 10.0, 32.0, 0.0),
                          child: Text(
                            "Em que você acha que podemos melhorar?\nSua opinião é muito importante para nós da $label",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 35.0,
                              color: Color(0xff0E314A),
                            ),
                          ),
                        ),
                        Container(
                          margin:
                              const EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 0.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(10.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 60.0, top: 10.0),
                                    child: Center(
                                        child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        getContainer(coluna1),
                                        getContainer(coluna2)
                                      ],
                                    )),
                                  ),
                                  Divider(),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        250.0, 10.0, 250.0, 0.0),
                                    child: new MaterialButton(
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                      ),
                                      height: 80.0,
                                      minWidth: 200.0,
                                      color: Color(0xff0E314A),
                                      textColor: Colors.white,
                                      child: new Text(
                                        "CONCLUIR",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0),
                                      ),
                                      onPressed: () {
                                        if (avaliacaoBean.tipoAvaliacao !=
                                            null) {
                                          postRequestAvaliacao();

                                          Route route = MaterialPageRoute(
                                              builder: (context) =>
                                                  ConcluidoPage());
                                          Navigator.pushReplacement(
                                              context, route);
                                        } else {
                                          _ackAlert(context);
                                        }
                                      },
                                      splashColor: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ));
                  } else {
                    return new Container();
                  }
                }
            }
          }),
    );
  }

  Widget getContainer(List<dynamic> list) {
    if (list != null) {
      return new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: list
              .map(
                (item) => new Container(
                  margin: EdgeInsets.all(5.0),
                  width: 350.0,
                  height: 65.0,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    border: new Border.all(
                        color: Color(0xff0E314A),
                        width: pressed && _item == item['id_tipoavaliacao']
                            ? 0.0
                            : 4.0),
                    borderRadius: new BorderRadius.circular(5.0),
                  ),
                  child: MaterialButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                    ),
                    minWidth: 200.0,
                    color: pressed && _item == item['id_tipoavaliacao']
                        ? (Colors.green)
                        : (Colors.white),
                    textColor: pressed && _item == item['id_tipoavaliacao']
                        ? (Colors.white)
                        : (Color(0xff0E314A)),
                    child: Text(
                      item['descricao'],
                      style: TextStyle(fontSize: 20.0, letterSpacing: 2.0),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      setState(() {
                        pressed = false;
                      });

                      Future.delayed(const Duration(milliseconds: 100), () {
                        setState(() {
                          _item = item['id_tipoavaliacao'];
                          pressed = true;
                        });
                      });

                      dynamic res = list
                          .where((l) => l['descricao'] == item['descricao'])
                          .toList()
                          .first;

                      avaliacaoBean.perfil = cfgBean.itemAvaliado;
                      avaliacaoBean.tipoAvaliacao = res['id_tipoavaliacao'];
                      avaliacaoBean.dtavaliacao = new DateTime.now().toString();
                      avaliacaoBean.comentario = "";
                    },
                    splashColor: Color(0xff2CA25F),
                  ),
                ),
              )
              .toList());
    } else
      return Container();
  }

  postRequestAvaliacao() async {
    final uri = "http://" +
        cfgBean.ip +
        "/pmz/service-satisfacao/index.php/satisfacaoAvaliacao/avaliacaoController/save";
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      'dtavaliacao': avaliacaoBean.dtavaliacao,
      'tipoAvaliacao': avaliacaoBean.tipoAvaliacao,
      'perfil': avaliacaoBean.perfil,
      'comentario': avaliacaoBean.comentario
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    http.Response response = await http.post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
  }

  Future<String> getData(String ip) async {
    return await http
        .get(
            "http://$ip/pmz/service-satisfacao/index.php/satisfacaoAvaliacao/tipoController/listaPorTipo?tipo=$_tipoAvaliacao")
        .then((result) {
      return result.body;
    });
  }

  void _getConfig() {
    _cfgDao.getConfig().then((obj) {
      setState(() {
        cfgBean = obj;
      });
    });
  }

  _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ATENÇÃO'),
          content: const Text(
            'Selecione uma opção !',
            style: TextStyle(fontSize: 20.0),
          ),
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
}
