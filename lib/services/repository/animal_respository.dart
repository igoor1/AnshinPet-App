import 'dart:convert';

import 'package:anshinpet/configs/app_url.dart';
import 'package:anshinpet/services/network/BaseApiServices.dart';
import 'package:anshinpet/services/network/NetworkApiService.dart';

class AnimalRespository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> fetchAnimals() async {
    dynamic response = await _apiServices.getAuthApiResponse(AppUrl.fetchAnimals);
    final Map<String, dynamic> jsonResponse = response;
    return jsonResponse['conteudo'];
  }
}