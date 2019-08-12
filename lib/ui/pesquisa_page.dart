import 'package:app_satisfacao/dao/config_dao.dart';
import 'package:app_satisfacao/dao/tipo_dao.dart';
import 'package:app_satisfacao/model/avaliacao_model.dart';
import 'package:app_satisfacao/model/config_model.dart';
import 'package:app_satisfacao/model/tipo_model.dart';
import 'package:app_satisfacao/service/avaliacao_service.dart';
import 'package:app_satisfacao/ui/experiencia_page.dart';
import 'package:app_satisfacao/utils/widgets_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  AvaliacaoService service = AvaliacaoService();

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
            "Avaliação de Atendimento",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40.0, color: Color(0xff0E314A)),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(
                    Radius.circular(8.0) //         <--- border radius here
                    )),
            width: 700.0,
            height: 350.0,
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
                          'Como avalia sua \nexperiência na $label ?',
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
                                    avaliacaoBean.comentario = "";
                                    service.postRequestAvaliacao(
                                        cfgBean.ip, avaliacaoBean, context);
                                  });
                                } else {
                                  Future.delayed(
                                      const Duration(milliseconds: 200), () {
                                    index++;
                                    Route route = MaterialPageRoute(
                                        builder: (context) =>
                                            ExperienciaPage(index));
                                    Navigator.pushReplacement(context, route);
                                  });
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

  void _getConfig() {
    _cfgDao.getConfig().then((obj) {
      setState(() {
        cfgBean = obj;
      });
    });
  }
}
