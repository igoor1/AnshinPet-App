class AnimalStatusModel {
  final int id;
  final String name;

  AnimalStatusModel({required this.id, required this.name});

  factory AnimalStatusModel.fromJson(Map<String, dynamic> json) {
    return AnimalStatusModel(
      id: json['id'],
      name: json['name'],
    );
  }
}