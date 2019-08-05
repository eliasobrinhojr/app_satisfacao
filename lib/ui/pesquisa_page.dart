import 'dart:convert';

import 'package:app_satisfacao/dao/config_dao.dart';
import 'package:app_satisfacao/dao/tipo_dao.dart';
import 'package:app_satisfacao/model/avaliacao_model.dart';
import 'package:app_satisfacao/model/config_model.dart';
import 'package:app_satisfacao/model/tipo_model.dart';
import 'package:app_satisfacao/ui/concluido_page.dart';
import 'package:app_satisfacao/ui/experiencia_page.dart';
import 'package:app_satisfacao/utils/widgets_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class PesquisaPage extends StatefulWidget {
  PesquisaPage();

  @override
  _PesquisaPageState createState() => _PesquisaPageState();
}

class _PesquisaPageState extends State<PesquisaPage>
    with SingleTickerProviderStateMixin {
  WidgetsUtil widUtil = WidgetsUtil();
  ConfigDao _cfgDao = ConfigDao();
  TipoDao _tipoDao = TipoDao();
  ConfigModel cfgBean = ConfigModel();
  AvaliacaoModel avaliacaoBean = AvaliacaoModel();
  AnimationController _controller;
  var _valueStar = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    _getConfig();
    _controller = AnimationController(vsync: this);
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var label = cfgBean != null ? cfgBean.itemAvaliado : "PMZ";

    return Scaffold(
      appBar: widUtil.getAppbar(),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Como você avalia o seu\natendimento?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30.0, color: Color(0xff0E314A)),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0) //         <--- border radius here
                    )),
            width: 600.0,
            height: 300.0,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 50.0, 0.0, 45.0),
                        child: Text(
                          'Conte-nos um pouco sobre sua\nexperiência na $label',
                          textAlign: TextAlign.center,
                          maxLines: null,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff0E314A),
                              fontSize: 28.0),
                        ),
                      ),
                      IconTheme(
                        data: IconThemeData(
                          color: Color(0xff0E314A),
                          size: 100,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _valueStar = index + 1;
                                });

                                if (index == 4) {
                                  avaliacaoBean.perfil = cfgBean.itemAvaliado;

                                  _tipoDao.buscaTipo().then((resp) {
                                    TipoModel tipo = resp.first;
                                    avaliacaoBean.tipoAvaliacao = tipo.idTipo;
                                    avaliacaoBean.dtavaliacao =
                                        new DateTime.now().toString();
                                    avaliacaoBean.comentario = " ";
                                    postRequestAvaliacao();
                                  });
                                } else {
                                  index++;
                                  Route route = MaterialPageRoute(
                                      builder: (context) =>
                                          ExperienciaPage(index));
                                  Navigator.pushReplacement(context, route);
                                }
                              },
                              child: Icon(
                                index < _valueStar
                                    ? Icons.star
                                    : Icons.star_border,
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      )),
    );
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

    if (statusCode == 200) {
      Route route = MaterialPageRoute(builder: (context) => ConcluidoPage());
      Navigator.pushReplacement(context, route);
    }
  }

  void _getConfig() {
    _cfgDao.getConfig().then((obj) {
      setState(() {
        cfgBean = obj;
      });
    });
  }
}
