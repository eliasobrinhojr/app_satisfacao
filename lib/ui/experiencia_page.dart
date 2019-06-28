import 'package:app_satisfacao/dao/config_dao.dart';
import 'package:app_satisfacao/model/config_model.dart';
import 'package:app_satisfacao/ui/concluido_page.dart';
import 'package:app_satisfacao/model/avaliacao_model.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:app_satisfacao/utils/widgets_util.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ExperienciaPage extends StatefulWidget {
  @override
  _ExperienciaPageState createState() => _ExperienciaPageState();
}

class _ExperienciaPageState extends State<ExperienciaPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  WidgetsUtil widUtil = WidgetsUtil();

  ConfigDao _cfgDao = ConfigDao();
  ConfigModel cfgBean = ConfigModel();

  AvaliacaoModel avaliacaoBean = AvaliacaoModel();

  @override
  void initState() {
    super.initState();
    _getConfig();
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
                return Center(
                  child: Text('Carregando Dados..',
                      style:
                          TextStyle(color: Color(0xff0E314A), fontSize: 25.0),
                      textAlign: TextAlign.center),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro ao Carregar Dados :(',
                        style:
                            TextStyle(color: Color(0xff0E314A), fontSize: 25.0),
                        textAlign: TextAlign.center),
                  );
                } else {
                  List<dynamic> lista = json.decode(snapshot.data);

                  List<String> listaStr = List<String>();
                  for (var item in lista) {
                    listaStr.add(item['descricao']);
                  }

                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
                        child: Text(
                          "O que ocasionou sua experiência negativa no $label ?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40.0,
                            color: Color(0xff0E314A),
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        width: 526.0,
                        height: 350.0,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(10.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                RadioButtonGroup(
                                  margin: EdgeInsets.all(20.0),
                                  labelStyle: TextStyle(
                                      fontSize: 20.0, wordSpacing: 10.0),
                                  labels: listaStr,
                                  onChange: (String label, int index) {
                                    print('change');
                                  },
                                  onSelected: (String label) {
                                    dynamic res = lista
                                        .where((l) => l['descricao'] == label)
                                        .toList();

                                    avaliacaoBean.perfil = cfgBean.itemAvaliado;
                                    avaliacaoBean.tipoAvaliacao =
                                        res[0]['id_tipoavaliacao'];
                                    avaliacaoBean.dtavaliacao =
                                        new DateTime.now().toString();
                                    avaliacaoBean.comentario = " ";
                                  },
                                ),
                                Divider(),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      150.0, 10.0, 150.0, 0.0),
                                  child: new MaterialButton(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                    ),
                                    height: 80.0,
                                    minWidth: 100.0,
                                    color: Color(0xff0E314A),
                                    textColor: Colors.white,
                                    child: new Text(
                                      "CONCLUIR",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    ),
                                    onPressed: () {
                                      if (avaliacaoBean.tipoAvaliacao != null) {
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
                }
            }
          }),
    );
  }

  postRequestAvaliacao() async {
    final uri = "http://" +
        cfgBean.ip +
        "/service-satisfacao/index.php/satisfacaoAvaliacao/avaliacaoController/save";
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
        .get("http://" +
            ip +
            "/service-satisfacao/index.php/satisfacaoAvaliacao/tipoController/listR")
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
