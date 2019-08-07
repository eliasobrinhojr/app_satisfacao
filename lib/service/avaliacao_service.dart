import 'package:app_satisfacao/model/avaliacao_model.dart';
import 'package:app_satisfacao/ui/concluido_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AvaliacaoService {
  var headers;

  AvaliacaoService() {
    this.headers = {'Content-Type': 'application/json'};
  }

  postRequestAvaliacao(
      String ip, AvaliacaoModel avaliacaoModel, BuildContext context) async {
    final uri =
        "http://$ip/pmz/service-satisfacao/index.php/satisfacaoAvaliacao/avaliacaoController/save";

    Map<String, dynamic> body = {
      'dtavaliacao': avaliacaoModel.dtavaliacao,
      'tipoAvaliacao': avaliacaoModel.tipoAvaliacao,
      'perfil': avaliacaoModel.perfil,
      'comentario': avaliacaoModel.comentario
    };

    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    http.Response response = await http.post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    String responseBody = response.body;
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      Route route = MaterialPageRoute(builder: (context) => ConcluidoPage());
      Navigator.pushReplacement(context, route);
    }
  }

  Future<String> getListaPorTipo(String ip, tipoAvaliacao) async {
    return await http
        .get(
            "http://$ip/pmz/service-satisfacao/index.php/satisfacaoAvaliacao/tipoController/listaPorTipo?tipo=$tipoAvaliacao")
        .then((result) => result.body);
  }
}
