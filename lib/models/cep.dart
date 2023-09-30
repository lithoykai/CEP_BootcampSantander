class CEP {
  String? objectId;
  String cep;
  String uf;
  String localidade;
  String bairro;
  String logradouro;

  CEP({
    this.objectId,
    required this.cep,
    required this.uf,
    required this.localidade,
    required this.bairro,
    required this.logradouro,
  });

  factory CEP.fromJson(Map<String, dynamic> json, String? id) {
    return CEP(
      objectId: id,
      cep: json['cep'],
      uf: json['uf'],
      localidade: json['localidade'],
      bairro: json['bairro'],
      logradouro: json['logradouro'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cep': cep,
      'uf': uf,
      'localidade': localidade,
      'bairro': bairro,
      'logradouro': logradouro,
    };
  }
}
