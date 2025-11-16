class DiseaseModel {
  final int id;
  final String name;
  final String severity;

  DiseaseModel({
    required this.id,
    required this.name,
    required this.severity,
  });

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Nome indisponível',
      severity: json['severity'] ?? 'BAIXA',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "severity": severity,
    };
  }
}
