import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:viacep_app/interface/cep_interface.dart';
import 'package:viacep_app/models/cep.dart';
import 'package:http/http.dart' as http;
import 'package:viacep_app/utils/constants.dart';

class CEPRepository implements CEPInterface {
  List<CEP> _items = [];
  @override
  Future<void> addNewCEP(CEP cep) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // adicionar um novo cep caso não possua no back4app
    // adicionar cep no Back4App
    print('CEP encontrado: ${cep.cep} / ${cep.bairro}');
    final response = await http.post(
        Uri.parse('https://parseapi.back4app.com/classes/ceps'),
        headers: Constants.headers,
        body: jsonEncode(cep.toJson()));
    final id = jsonDecode(response.body)['objectId'];
    cep.objectId = id;
    print('CEP SENDO ADICIONADO NA LISTA');
    _items.add(cep);
    await fetchAllCEP();
    notifyListeners();
  }

  @override
  Future<void> fetchCEP() async {}

  @override
  Future<void> getNewCEPByViaCep(String cep) async {
    await Future.delayed(const Duration(seconds: 2));
    // pega o cepp do viaCep e manda para addNewCep adicionar na lista e no Back4App
    var hasCEP = items.where((element) => element.cep == cep);
    if (hasCEP.isNotEmpty) {
      print('CEP já existe.');
      return;
    }

    print('CEP não encontrado nos items salvos. Procurando no ViaCEP');
    final viaCepReponse =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
    if (viaCepReponse.statusCode == 200) {
      final data = jsonDecode(viaCepReponse.body);
      print('CEP sendo adicionado na função addNewCEP');
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
    await Future.delayed(const Duration(milliseconds: 200));
    _items.clear();
    final response = await http.get(
      Uri.parse('https://parseapi.back4app.com/classes/ceps'),
      headers: Constants.headers,
    );
    dynamic data = jsonDecode(response.body)['results'];
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

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => throw UnimplementedError();

  @override
  void maybeDispatchObjectCreation() {
    // TODO: implement maybeDispatchObjectCreation
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }
}
