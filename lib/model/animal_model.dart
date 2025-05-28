class AnimalModel {
  int? id;
  String? nome;
  String? sexo;
  String? tipo;
  String? cor;
  String? porte;
  String? castrado;
  String? adocao;
  String? raca;

  AnimalModel({
    this.id,
    this.nome,
    this.sexo,
    this.tipo,
    this.cor,
    this.porte,
    this.castrado,
    this.adocao,
    this.raca
  });

  AnimalModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    nome = json['nome'];
    sexo = json['sexo'];
    tipo = json['tipo'];
    cor = json['cor'];
    porte = json['porte'];
    castrado = json['castrado'];
    adocao = json['adocao'];
    raca = json['raca'];
  }

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'nome': nome,
      'sexo': sexo,
      'tipo': tipo,
      'cor': cor,
      'porte': porte,
      'castrado': castrado,
      'adocao': adocao,
      'raca': raca
    };
  }
}
