class Vaccine {
  final int id;
  final String name;
  final String manufacturer;

  Vaccine({
    required this.id,
    required this.name,
    required this.manufacturer,
  });

  factory Vaccine.fromJson(Map<String, dynamic> json) {
    return Vaccine(
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
