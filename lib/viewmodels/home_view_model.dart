import 'package:anshinpet/services/repository/home_repository.dart';
import 'package:flutter/widgets.dart';

class HomeViewModel with ChangeNotifier{
  final HomeRepository _homeRepo = HomeRepository();

  int _quantityAnimals = 0;
  int get quantityAnimals => _quantityAnimals;

  int _quantityDogs = 0;
  int get quantityDogs => _quantityDogs;

  int _quantityCats = 0;
  int get quantityCats => _quantityCats;

  int _quantityBirds = 0;
  int get quantityBirds => _quantityBirds;

  int _quantityAdoption = 0;
  int get quantityAdoption => _quantityAdoption;

  int _quantityUsers = 0;
  int get quantityUsers => _quantityUsers;

  int _quantityDonations = 0;
  int get quantityDonations => _quantityDonations;

  int _quantityMoney = 0;
  int get quantityMoney =>_quantityMoney;


  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchHomeData() async {
    setLoading(true);
    notifyListeners();

    try {
      _quantityAnimals = await _homeRepo.quantityAnimals();
      _quantityDogs = await _homeRepo.quantityDogs();
      _quantityCats = await _homeRepo.quantityCats();
      _quantityBirds = await _homeRepo.quantityBirds();
      _quantityUsers = await _homeRepo.quantityUsers();
      _quantityDonations = await _homeRepo.quantityDonations();
      _quantityMoney = await _homeRepo.quantityMoney();

      notifyListeners();

    } catch (error) {
      debugPrint("Erro ao buscar dados: $error");
    }

    setLoading(false);
    notifyListeners();
  }
}

