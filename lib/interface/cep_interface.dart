import 'package:flutter/material.dart';
import 'package:viacep_app/models/cep.dart';

abstract class CEPInterface with ChangeNotifier {
  List<CEP> items = [];
  Future<void> fetchCEP() async {}
  Future<List<CEP>> fetchAllCEP() async {
    return [];
  }

  Future<void> addNewCEP(CEP cep) async {}

  Future<void> removeCEP(CEP cep) async {}

  Future<void> getNewCEPByViaCep(String cep) async {}

  Future<void> updateCEP(CEP cep) async {}
}
