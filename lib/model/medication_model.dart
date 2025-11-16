class MedicationModel {
  final int? id;
  final String name;
  final String manufacturer;
  final String batch;

  MedicationModel({
    this.id,
    required this.name,
    required this.manufacturer,
    required this.batch,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      id: json['id'],
      name: json['name'],
      manufacturer: json['manufacturer'],
      batch: json['batch'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'manufacturer': manufacturer,
      'batch': batch,
    };
  }
}
