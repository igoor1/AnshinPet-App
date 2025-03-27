import 'package:anshinpet/repository/auth_repository.dart';
import 'package:anshinpet/configs/routes/routes_name.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthViewModel with ChangeNotifier {

    final _authRepo = AuthRepository();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value){
    _loading = value;
    notifyListeners();
  }

  Future<void> loginApi(dynamic data, BuildContext context) async {
    try{
      setLoading(true);
      var value = await _authRepo.loginApi(data);
      setLoading(false);
      Navigator.pushNamed(context, RoutesName.home);
      if (kDebugMode) print(value.toString());
    }catch (e) {
      setLoading(false);
      throw Exception(e);
    }
  }
}