import 'dart:io';
import 'package:anshinpet/configs/app_url.dart';
import 'package:anshinpet/services/network/BaseApiServices.dart';
import 'package:anshinpet/services/network/NetworkApiService.dart';

class AnimalRepository {
  final BaseApiServices _apiServices = NetworkApiService();

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

  // --- CORREÇÃO AQUI ---
  Future<Map<String, dynamic>> uploadAnimalImage(
    int animalId, 
    File imageFile,   // Trocado de 'bytes/filename' para 'File'
    String? description
  ) async {
    
    final response = await _apiServices.multipartRequestApiResponse(
      'PUT', // Usa o método PUT
      AppUrl.uploadAnimalImage(animalId),
      imageFile, // Passa o objeto File
      description != null ? {'description': description} : null,
    );
    return response;
  }
}