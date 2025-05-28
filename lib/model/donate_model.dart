class DonateModel {
  int? id;
  String? tipo;
  double? valor;
  int? quantidade;
  String? descricao;
  String? data;

  DonateModel({
    this.id,
    this.tipo, 
    this.valor, 
    this.quantidade, 
    this.descricao, 
    this.data
  });

  DonateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tipo = json['tipo'];
    valor = json['valor'];
    quantidade = json['quantidade'];
    descricao = json['descricao'];
    data = json['data'];
  }

   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo,
      'valor': valor,
      'quantidade': quantidade,
      'descricao': descricao,
      'data': data,
    };
   }
}