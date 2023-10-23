// ignore_for_file: unused_import

import 'dart:convert';

import 'package:app_doc/database/database_app.dart';
import 'package:app_doc/provider/api_url_provider.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class FotoProvider {
  final _apiUrl = ApiUrlProvider.getApiUrl();

  Future getCargaAPI(int idUsuario) {
    return http.get(
      Uri.parse('$_apiUrl/retornofoto/upload-img'),
    );
  }

  // Future<List<int>>  sincronizarRetornoFoto(List<Object>listaSincFoto) async {
  //    try{
  //      List<int> lista =[];
  //      String url = '$_apiUrl/retorno-foto/incluir';
  //      String strBody = jsonEncode(listaSincFoto.map((e) => e.toJson()).toList()).toString();
  //      Map<String, String> headers = {
  //        'Accept': 'application/json',
  //        'Content-Type': 'application/json'
  //      };
  //      http.Response response = await http.post(headers: headers, Uri.parse(url), body: strBody);
  //      dynamic dadosJson = json.decode(utf8.decode(response.body.codeUnits));
  //      if(response.statusCode != 200){
  //        //ToastMesage.showToastError("Sem resposta do servidor");
  //      }else{
  //        for(var idServico in dadosJson){
  //          lista.add(idServico);
  //        }
  //        return lista;
  //      }
  //      return lista;
  //    }catch(error){
  //      print(error);
  //      throw Exception();
  //    }
  //  }

  Future<void> insert(Map<String, dynamic> data) async {
    DatabaseApp.insert('retorno_foto', data);
  }
}
