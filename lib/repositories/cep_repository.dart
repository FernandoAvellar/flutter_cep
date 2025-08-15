import 'dart:convert';

import 'package:flutter_cep/models/cep_model.dart';
import 'package:http/http.dart' as http;

class CepRepository {
  static const String baseUrl = 'https://viacep.com.br/ws/';
  final http.Client client;

  CepRepository({required this.client});

  Future<CepModel> consultarCep(String cep) async {
    try {
      final cleanCep = cep.replaceAll(RegExp(r'[^0-9]'), '');
      if (cleanCep.length != 8) {
        throw ArgumentError.value(cep, 'cep', 'CEP deve ter 8 dígitos');
      }

      final url = Uri.https('viacep.com.br', '/ws/$cleanCep/json', {});
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        if (jsonData['erro'] != null) {
          throw Exception('CEP não encontrado');
        }
        return CepModel.fromJson(jsonData);
      } else {
        throw Exception('Erro na requisição');
      }
    } on Exception catch (_) {
      throw Exception('Erro ao realizar a requisição');
    }
  }
}
