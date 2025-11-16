class VaccineModel {
  final int id;
  final String name;
  final String manufacturer;

  VaccineModel({
    required this.id,
    required this.name,
    required this.manufacturer,
  });

  factory VaccineModel.fromJson(Map<String, dynamic> json) {
    return VaccineModel(
      id: json["id"],
      name: json["name"],
      manufacturer: json["manufacturer"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "manufacturer": manufacturer,
    };
  }
}
