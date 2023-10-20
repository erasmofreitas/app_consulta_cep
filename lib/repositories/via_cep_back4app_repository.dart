import 'package:app_consulta_cep/models/viacep_model.dart';
import 'package:dio/dio.dart';

class ViaCepBack4AppRepository {
  var _dio = Dio();

  ViaCepBack4AppRepository() {
    _dio = Dio();
    _dio.options.headers["X-Parse-Application-Id"] =
        "0iYudUqNCKD2LGtX1wAaoZGpXX62aTFbucbv8hh2";
    _dio.options.headers["X-Parse-REST-API-Key"] =
        "l0b4JYiw8KkryospFnfgmG5A4I4gc1JpZy6Uj7Ke";
    _dio.options.headers["content-type"] = "application/json";
    _dio.options.baseUrl = 'https://parseapi.back4app.com/classes';
  }
  Future<ViaCEPModel> getCeps(String? cep) async {
    var url = "/ConsultaCep";
    if (cep != null) {
      url = "$url?where={\"cep\":\"$cep\"}";
    }
    var result = await _dio.get(url);
    return ViaCEPModel.fromJson(result.data);
  }

  Future<void> gravarCep(ConsultaViaCep model) async {
    try {
      var url = "/ConsultaCep";
      await _dio.post(url, data: model.toCreateJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> atualizar(ConsultaViaCep model) async {
    try {
      var response = await _dio.put("/ConsultaCep/${model.objectId}",
          data: model.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> remover(String objectId) async {
    try {
      await _dio.delete(
        "/ConsultaCep/$objectId",
      );
    } catch (e) {
      rethrow;
    }
  }
}
