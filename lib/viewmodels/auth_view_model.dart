import 'package:anshinpet/services/repository/auth_repository.dart';
import 'package:anshinpet/configs/routes/routes_name.dart';
import 'package:anshinpet/viewmodels/token_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthViewModel with ChangeNotifier {
  final _authRepo = AuthRepository();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> loginApi(dynamic data, BuildContext context) async {
    setLoading(true);
    try {
      var value = await _authRepo.loginApi(data);
      final tokenValue = Provider.of<TokenViewModel>(context, listen: false);
      await tokenValue.saveToken(value);

      setLoading(false);

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.animal,
          (route) => false,
        );
      }

      if (kDebugMode) print(value.toString());
    } catch (e) {
      setLoading(false);
      rethrow;
    }
  }

  Future<void> logout(BuildContext context) async {
    final tokenValue = Provider.of<TokenViewModel>(context, listen: false);

    await tokenValue.remove();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.login,
        (route) => false,
      );
    }
  }
}