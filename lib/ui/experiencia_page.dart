import 'dart:async';
import 'dart:convert';
import 'package:app_satisfacao/dao/config_dao.dart';
import 'package:app_satisfacao/model/avaliacao_model.dart';
import 'package:app_satisfacao/model/config_model.dart';
import 'package:app_satisfacao/service/avaliacao_service.dart';
import 'package:app_satisfacao/ui/concluido_page.dart';
import 'package:app_satisfacao/utils/widgets_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  AvaliacaoService service = AvaliacaoService();

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
          future: service.getListaPorTipo(cfgBean.ip, _tipoAvaliacao),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              default:
                if (!snapshot.hasError) {
                  if (snapshot.data != null) {
                    var lista = json.decode(snapshot.data);
                    var coluna1 = List(), coluna2 = List();

                    lista.asMap().forEach((i, value) =>
                        i < 3 ? coluna1.add(value) : coluna2.add(value));

                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(32.0, 10.0, 32.0, 0.0),
                          child: Text(
                            "Como podemos melhorar?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 35.0,
                              color: Color(0xff0E314A),
                            ),
                          ),
                        ),
                        Container(
                          margin:
                              const EdgeInsets.fromLTRB(70.0, 20.0, 50.0, 0.0),
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
                                          service.postRequestAvaliacao(
                                              cfgBean.ip,
                                              avaliacaoBean,
                                              context);
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
                } else {
                  return new Container();
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

                      var res = list
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
