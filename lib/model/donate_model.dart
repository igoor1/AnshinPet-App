class DonateModel {

  String? tipo;
  double? valor;
  int? quantidade;
  String? descricao;
  String? data;

  DonateModel({
    this.tipo, 
    this.valor, 
    this.quantidade, 
    this.descricao, 
    this.data
  });

  DonateModel.fromJson(Map<String, dynamic> json) {
    tipo = json['tipo'];
    valor = json['valor'];
    quantidade = json['quantidade'];
    descricao = json['descricao'];
    data = json['data'];
  }
}