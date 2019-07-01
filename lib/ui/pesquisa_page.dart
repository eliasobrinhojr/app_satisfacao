import 'dart:convert';
import 'package:app_satisfacao/dao/tipo_dao.dart';
import 'package:app_satisfacao/model/tipo_model.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:app_satisfacao/dao/config_dao.dart';
import 'package:app_satisfacao/model/avaliacao_model.dart';
import 'package:app_satisfacao/model/config_model.dart';
import 'package:app_satisfacao/ui/concluido_page.dart';
import 'package:app_satisfacao/ui/experiencia_page.dart';
import 'package:flutter/material.dart';
import 'package:app_satisfacao/utils/widgets_util.dart';

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

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    _getConfig();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var assetsBom = new AssetImage('lib/assets/ic_bom.png');
    var imageBom = new Image(image: assetsBom, width: 110.0, height: 110.0);

    var assetsRuim = new AssetImage('lib/assets/ic_ruim.png');
    var imageRuim = new Image(image: assetsRuim, width: 110.0, height: 110.0);

    var label = cfgBean.itemAvaliado;

    return Scaffold(
      appBar: widUtil.getAppbar(),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Como você avalia nosso atendimento\n no $label ?",
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
            width: 526.0,
            height: 320.0,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 50.0, 0.0, 60.0),
                        child: Text(
                          'Ficou satisfeito com a\n sua experiência na PMZ?',
                          textAlign: TextAlign.center,
                          maxLines: null,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff0E314A),
                              fontSize: 28.0),
                        ),
                      ),
                      Divider(),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                            child: new MaterialButton(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                              ),
                              height: 80.0,
                              minWidth: 200.0,
                              color: Color(0xff0E314A),
                              textColor: Colors.white,
                              child: Row(
                                children: <Widget>[
                                  new Container(child: imageBom),
                                  Text(
                                    "BOM",
                                    style: TextStyle(
                                        fontSize: 20.0, letterSpacing: 3.0),
                                  )
                                ],
                              ),
                              onPressed: () {
                                avaliacaoBean.perfil = cfgBean.itemAvaliado;

                                _tipoDao.buscaTipo().then((resp) {
                                  List<TipoModel> list = resp;
                                  avaliacaoBean.tipoAvaliacao = list[0].idTipo;

                                  avaliacaoBean.dtavaliacao =
                                      new DateTime.now().toString();
                                  avaliacaoBean.comentario = " ";

                                  postRequestAvaliacao();

                                  Route route = MaterialPageRoute(
                                      builder: (context) => ConcluidoPage());
                                  Navigator.pushReplacement(context, route);
                                });
                              },
                              splashColor: Colors.black,
                            ),
                          )),
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                            child: new MaterialButton(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                              ),
                              height: 80.0,
                              minWidth: 200.0,
                              color: Color(0xff0E314A),
                              textColor: Colors.white,
                              child: Row(
                                children: <Widget>[
                                  new Container(child: imageRuim),
                                  Text(
                                    "RUIM",
                                    style: TextStyle(
                                        fontSize: 20.0, letterSpacing: 3.0),
                                  )
                                ],
                              ),
                              onPressed: () {
                                Route route = MaterialPageRoute(
                                    builder: (context) => ExperienciaPage());
                                Navigator.pushReplacement(context, route);
                              },
                              splashColor: Colors.black,
                            ),
                          )),
                        ],
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

  void _getConfig() {
    _cfgDao.getConfig().then((obj) {
      setState(() {
        cfgBean = obj;
      });
    });
  }
}
