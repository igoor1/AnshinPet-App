class VaccineModel {
  final int id;
  final String name;
  final String producer;

  VaccineModel({
    required this.id,
    required this.name,
    required this.producer,
  });

  factory VaccineModel.fromJson(Map<String, dynamic> json) {
    return VaccineModel(
      id: json['id'] ?? 0,
      name: json['nome'] ?? 'Nome indisponível',
      producer: json['fabricante'] ?? 'Descrição não disponível.',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': name, 
      'fabricante': producer,
    };
  }
}