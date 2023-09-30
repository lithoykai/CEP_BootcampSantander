import 'dart:convert';

import 'package:viacep_app/interface/cep_interface.dart';
import 'package:viacep_app/models/cep.dart';
import 'package:http/http.dart' as http;
import 'package:viacep_app/utils/constants.dart';

class CEPRepository implements CEPInterface {
  List<CEP> _items = [];
  @override
  Future<void> addNewCEP(CEP cep) async {
    // adicionar um novo cep caso não possua no back4app
    // adicionar cep no Back4App

    final response = await http.post(
        Uri.parse('https://parseapi.back4app.com/classes/ceps'),
        headers: Constants.headers,
        body: jsonEncode(cep.toJson()));
    final id = jsonDecode(response.body)['objectId'];
    cep.objectId = id;
    _items.add(cep);
  }

  @override
  Future<void> fetchCEP() async {}

  @override
  Future<void> getNewCEPByViaCep(String cep) async {
    // pega o cepp do viaCep e manda para addNewCep adicionar na lista e no Back4App

    if (cep.length < 8 || cep.length > 8) {
      return;
    }
    final viaCepReponse =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
    if (viaCepReponse.statusCode == 200) {
      final data = jsonDecode(viaCepReponse.body);
      await addNewCEP(CEP.fromJson(data, ''));
    }
  }

  @override
  Future<void> removeCEP(CEP cep) async {
    final deleteResponse = await http.delete(
      Uri.parse('https://parseapi.back4app.com/classes/ceps/${cep.objectId}'),
      headers: Constants.headers,
    );
    if (deleteResponse.statusCode == 200) {
      _items.remove(cep);
      // print('deletado com sucesso');
    }
  }

  @override
  Future<void> updateCEP(CEP cep) {
    // TODO: implement updateCEP
    throw UnimplementedError();
  }

  @override
  Future<List<CEP>> fetchAllCEP() async {
    _items.clear();
    final response = await http.get(
      Uri.parse('https://parseapi.back4app.com/classes/ceps'),
      headers: Constants.headers,
    );
    List<dynamic> data = jsonDecode(response.body)['results'];
    data.forEach((json) {
      // print('Key $key');
      _items.add(CEP.fromJson(json, json['objectId']));
      print('adicionado');
      // print(value);
    });
    return _items;
    // print(response.body);
  }

  @override
  set items(List<CEP> _items) {
    // TODO: implement items
  }

  @override
  // TODO: implement items
  List<CEP> get items => [..._items];
}
