import 'dart:convert';
import 'package:anshinpet/configs/app_url.dart';
import 'package:http/http.dart' as http;

class MedicationRepository {
  // Usa a URL do AppUrl
  final String baseUrl = AppUrl.medicationUrl;

  // Buscar todos os medicamentos
  Future<List<dynamic>> fetchMedications() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao buscar medicamentos: ${response.statusCode}');
    }
  }

  // Criar um medicamento
  Future<Map<String, dynamic>> createMedication(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao criar medicamento: ${response.statusCode}');
    }
  }

  Future<void> deleteMedication(int id) async {
    final response = await http.delete(Uri.parse(AppUrl.deleteMedications(id)));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Falha ao deletar medicamento: ${response.statusCode}');
    }
  }
}
