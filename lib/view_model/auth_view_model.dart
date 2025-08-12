import 'package:anshinpet/repository/auth_repository.dart';
import 'package:anshinpet/configs/routes/routes_name.dart';
import 'package:anshinpet/view_model/token_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthViewModel with ChangeNotifier {

    final _authRepo = AuthRepository();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value){
    _loading = value;
    notifyListeners();
  }

  Future<void> loginApi(dynamic data, BuildContext context) async {
    setLoading(true);
    try{
      var value = await _authRepo.loginApi(data);
      final tokenValue = Provider.of<TokenViewModel>(context, listen: false);
      tokenValue.saveToken(value);     

      Navigator.pushNamed(context, RoutesName.home);
      setLoading(false);
      if (kDebugMode) print(value.toString());
    }catch (e) {
      setLoading(false);
      throw Exception(e);
    }
  }
}