import 'package:anshinpet/model/animal_status_model.dart';
import 'package:anshinpet/model/animal_type_model.dart';

class AnimalModel {
  final int? id;
  final String? name;
  final String? color;
  final String? gender;
  final String? birthDate;
  final String? breed;
  final String? description;
  final String? rescueDate;
  final AnimalTypeModel? animalType;
  final AnimalStatusModel? animalStatus;

  AnimalModel({
    this.id,
    this.name,
    this.color,
    this.gender,
    this.birthDate,
    this.breed,
    this.description,
    this.rescueDate,
    this.animalType,
    this.animalStatus,
  });

  factory AnimalModel.fromJson(Map<String, dynamic> json) {
    return AnimalModel(
      // Mapeamento direto
      id: json['id'],
      name: json['name'],
      color: json['color'],
      gender: json['gender'],
      breed: json['breed'],
      description: json['description'],
      
      birthDate: json['birth_date'],
      rescueDate: json['rescue_date'],

      animalType: json['animalType'] != null
          ? AnimalTypeModel.fromJson(json['animalType'])
          : null,
      animalStatus: json['animalStatus'] != null
          ? AnimalStatusModel.fromJson(json['animalStatus'])
          : null,
    );
  }
}