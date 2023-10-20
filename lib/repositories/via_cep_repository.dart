import 'dart:convert';
import 'package:app_consulta_cep/repositories/via_cep_back4app_repository.dart';
import 'package:http/http.dart' as http;

import '../models/viacep_model.dart';

class ViaCepRepository {
  ViaCepBack4AppRepository _back4appRepository = ViaCepBack4AppRepository();
  Future<ConsultaViaCep> consultarCEP(String cep) async {
    var response =
        await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json/"));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var model = ConsultaViaCep.fromJson(json);
      var responseCep = await _back4appRepository.getCeps(model.cep);
      if (responseCep.results!.isEmpty) {
        await _back4appRepository.gravarCep(model);
      }
      return model;
    }
    return ConsultaViaCep();
  }
}
