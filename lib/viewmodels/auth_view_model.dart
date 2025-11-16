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

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> loginApi(dynamic data, BuildContext context) async {
    setLoading(true);
    setError(null);
    try {
      var tokenModel = await _authRepo.loginApi(data);

      if (tokenModel.token == null || tokenModel.token!.isEmpty) {
        setError("Email ou senha inválidos.");
        setLoading(false);
        return;
      }

      final tokenValue = Provider.of<TokenViewModel>(context, listen: false);
      await tokenValue.saveToken(tokenModel);

      setLoading(false);

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.animal,
          (route) => false,
        );
      }

      if (kDebugMode) print(tokenModel.token);
    } catch (e) {
      setLoading(false);
      setError("Erro ao realizar login. Verifique sua conexão.");
      if (kDebugMode) print(e.toString());
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
