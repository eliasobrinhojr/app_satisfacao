import 'package:app_satisfacao/ui/pesquisa_page.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:app_satisfacao/utils/widgets_util.dart';
import 'package:flutter/services.dart';

class ConcluidoPage extends StatefulWidget {
  @override
  _ConcluidoPageState createState() => _ConcluidoPageState();
}

class _ConcluidoPageState extends State<ConcluidoPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  WidgetsUtil widUtil = WidgetsUtil();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);

    Future.delayed(const Duration(milliseconds: 1500), () {
      Route route = MaterialPageRoute(builder: (context) => PesquisaPage());
      Navigator.pushReplacement(context, route);
    });
  }

  @override
  Widget build(BuildContext context) {
    var assetsImage = new AssetImage('lib/assets/check.png');
    var image = new Image(image: assetsImage, width: 167.0, height: 167.0);

    return Scaffold(
      appBar: getAppbar(),
      backgroundColor: Color(0xff4CAF50),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    new Container(child: image),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 50.0, 0.0, 30.0),
                      child: Text(
                        'Muito obrigado,\n a PMZ agradece a preferência',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
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
            )
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
