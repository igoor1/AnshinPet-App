import 'package:anshinpet/model/donate_model.dart';
import 'package:anshinpet/repository/donate_repository.dart';
import 'package:flutter/widgets.dart';

class DonationViewModel with ChangeNotifier{

  final DonateRepository _donateRepository = DonateRepository();

  List<DonateModel> _donations = [];
  List<DonateModel> get donations => _donations;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> fetchDonations(String typeDonation) async {
    _loading = true;
    notifyListeners();

    try {
      final response = await _donateRepository.fetchDonations(typeDonation);
      _donations = response.map<DonateModel>((json) => DonateModel.fromJson(json)).toList();
    } catch (e) {
      _donations = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> deleteDonation(int id) async {
    _loading = true;
    notifyListeners();

    try {
      await _donateRepository.deleteDonation(id);
      _donations.removeWhere((donation) => donation.id == id);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

   Future<void> createDonation(Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();

    try {
      final json = await _donateRepository.createDonation(data);
      final newDonation = DonateModel.fromJson(json);
      _donations.add(newDonation);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}