import 'dart:convert';
import 'package:basic_utils/basic_utils.dart';
import 'package:viacep_app/exception/custom_exception.dart';
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
    try {
      final response = await http.post(
          Uri.parse('https://parseapi.back4app.com/classes/ceps'),
          headers: Constants.headers,
          body: jsonEncode(cep.toJson()));
      final id = jsonDecode(response.body)['objectId'];
      cep.objectId = id;
    } catch (error) {
      throw CustomException(msg: error.toString());
    }
    _items.add(cep);
    await fetchAllCEP();
  }

  @override
  Future<void> fetchCEP() async {}

  @override
  Future<void> getNewCEPByViaCep(String cep) async {
    await Future.delayed(const Duration(seconds: 2));
    String newCep = StringUtils.addCharAtPosition(cep, "-", 5);
    var hasCEP = items.where((element) => element.cep == newCep).toList();
    if (hasCEP.isNotEmpty) {
      throw CustomException(
          msg: 'Esse CEP já está na sua lista.', statusCode: 0);
    }

    final viaCepReponse =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
    if (viaCepReponse.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(viaCepReponse.body);
      if (data.containsKey('erro')) {
        throw CustomException(msg: 'Esse CEP não existe!');
      }
      await addNewCEP(CEP.fromJson(data, ''));
    } else if (viaCepReponse.statusCode == 400) {
      throw CustomException(
          msg: 'Houve algum problema, esse CEP está correto?');
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
    dynamic data = jsonDecode(response.body);
    List dataKeys = data['results'];
    if (data == null) {
      throw CustomException(msg: 'Houve um problema a obter os dados.');
    }
    for (var json in dataKeys) {
      _items.add(CEP.fromJson(json, json['objectId']));
    }
    return _items;
  }

  @override
  set items(List<CEP> _items) {
    // TODO: implement items
  }

  @override
  // TODO: implement items
  List<CEP> get items => [..._items];
}
