import 'dart:io';
import 'package:anshinpet/configs/app_url.dart';
import 'package:anshinpet/services/network/BaseApiServices.dart';
import 'package:anshinpet/services/network/NetworkApiService.dart';

class AnimalRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  // --- Animais ---
  Future<dynamic> fetchAnimals({int page = 0, int limit = 12}) async {
    final String url = '${AppUrl.fetchAnimals}?page=$page&size=$limit';
    final response = await _apiServices.getAuthApiResponse(url);
    return response;
  }

  Future<Map<String, dynamic>> createAnimal(Map<String, dynamic> data) async {
    final response = await _apiServices.getAuthPostApiResponse(AppUrl.createAnimal, data);
    return response;
  }

  Future<Map<String, dynamic>> updateAnimal(int id, Map<String, dynamic> data) async {
    final response = await _apiServices.putApiResponse(AppUrl.updateAnimal(id), data);
    return response;
  }

  Future<void> deleteAnimal(int id) async {
    await _apiServices.deleteApiResponse(AppUrl.deleteAnimal(id));
  }

  Future<Map<String, dynamic>> uploadAnimalImage(
    int animalId, 
    File imageFile,
    String? description,
  ) async {
    final response = await _apiServices.multipartRequestApiResponse(
      'PUT',
      AppUrl.uploadAnimalImage(animalId),
      imageFile,
      description != null ? {'description': description} : null,
    );
    return response;
  }

  // --- Vacinas do animal ---
  Future<List<dynamic>> fetchAnimalVaccines(int animalId) async {
    final String url = '${AppUrl.baseUrl}/api/animals/$animalId/vaccines';
    final response = await _apiServices.getAuthApiResponse(url);
    return response;
  }

  // --- Doenças do animal ---
  Future<List<dynamic>> fetchAnimalDiseases(int animalId) async {
    final String url = '${AppUrl.baseUrl}/api/animals/$animalId/diseases';
    final response = await _apiServices.getAuthApiResponse(url);
    return response;
  }

  // --- Medicações do animal ---
  Future<List<dynamic>> fetchAnimalMedications(int animalId) async {
    final String url = '${AppUrl.baseUrl}/api/animals/$animalId/medications';
    final response = await _apiServices.getAuthApiResponse(url);
    return response;
  }
}
