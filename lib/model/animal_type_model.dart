class AnimalTypeModel {
  final int id;
  final String name;

  AnimalTypeModel({required this.id, required this.name});

  factory AnimalTypeModel.fromJson(Map<String, dynamic> json) {
    return AnimalTypeModel(
      id: json['id'],
      name: json['name'],
    );
  }
}