import 'dart:io';
import 'package:anshinpet/model/animal_model.dart';
import 'package:anshinpet/services/repository/animal_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AnimalViewModel with ChangeNotifier {
  final AnimalRepository _animalRepository = AnimalRepository();

  List<AnimalModel> _animals = [];
  List<AnimalModel> get animals => _animals;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  Future<void> fetchAllAnimals({int limitPerPage = 12}) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      int page = 0;
      bool hasMore = true;
      List<AnimalModel> loaded = [];

      while (hasMore) {
        final response = await _animalRepository.fetchAnimals(page: page, limit: limitPerPage);

        if (response is List) {
          final pageAnimals = response.map<AnimalModel>((j) => AnimalModel.fromJson(j as Map<String, dynamic>)).toList();
          loaded.addAll(pageAnimals);
          hasMore = false;
        } else if (response is Map<String, dynamic>) {
          List<dynamic> content = [];

          if (response.containsKey('content') && response['content'] is List) {
            content = response['content'] as List<dynamic>;
          } else if (response.containsKey('data') && response['data'] is List) {
            content = response['data'] as List<dynamic>;
          } else if (response.containsKey('conteudo') && response['conteudo'] is List) {
            content = response['conteudo'] as List<dynamic>;
          } else {
            if (response.containsKey('id')) {
              loaded.add(AnimalModel.fromJson(response));
            }
            hasMore = false;
            break;
          }

          final pageAnimals = content.map<AnimalModel>((j) => AnimalModel.fromJson(j as Map<String, dynamic>)).toList();
          loaded.addAll(pageAnimals);

          if (response.containsKey('last')) {
            final lastVal = response['last'];
            if (lastVal is bool) {
              hasMore = !lastVal;
            } else {
              hasMore = pageAnimals.length >= limitPerPage;
            }
          } else if (pageAnimals.length < limitPerPage) {
            hasMore = false;
          } else {
            hasMore = pageAnimals.isNotEmpty;
          }

          page++;
        } else {
          throw Exception('Formato de resposta inesperado ao buscar animais: ${response.runtimeType}');
        }
      }

      _animals = loaded;
    } catch (e) {
      _error = 'Erro ao carregar animais: ${e.toString()}';
      if (kDebugMode) print(_error);
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<AnimalModel?> createAnimal(Map<String, dynamic> data) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _animalRepository.createAnimal(data);
      final newAnimal = AnimalModel.fromJson(response);

      _animals.insert(0, newAnimal);
      return newAnimal; 
    } catch (e) {
      _error = 'Erro ao criar animal: ${e.toString()}';
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<AnimalModel?> updateAnimal(int id, Map<String, dynamic> data) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _animalRepository.updateAnimal(id, data);
      final updatedAnimal = AnimalModel.fromJson(response);
      
      final index = _animals.indexWhere((a) => a.id == id);
      if (index != -1) {
        _animals[index] = updatedAnimal;
      }
      
      return updatedAnimal;
    } catch (e) {
      _error = 'Erro ao atualizar animal: ${e.toString()}';
      rethrow; 
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteAnimal(int id) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _animalRepository.deleteAnimal(id);
      _animals.removeWhere((a) => a.id == id);
      return true;
    } catch (e) {
      _error = 'Erro ao deletar animal: ${e.toString()}';
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

Future<AnimalModel?> uploadAnimalImage(
    int animalId, 
    File imageFile,
    String? description
  ) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _animalRepository.uploadAnimalImage(animalId, imageFile, description);
      final updatedAnimal = AnimalModel.fromJson(response);

      final index = _animals.indexWhere((a) => a.id == animalId);
      if (index != -1) {
        _animals[index] = updatedAnimal;
      }
      
      return updatedAnimal;
    } catch (e) {
      _error = 'Erro ao fazer upload da imagem: ${e.toString()}';
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}