

class DiseaseModel {
  final int id;
  final String name;
  final String description;

  DiseaseModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      id: json['id'] ?? 0,
      name: json['nome'] ?? 'Nome indisponível',
      description: json['gravidade'] ?? 'Descrição não disponível.',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': name, 
      'gravidade': description,
    };
  }
}