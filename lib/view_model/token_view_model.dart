import 'package:anshinpet/model/token_model.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenViewModel with ChangeNotifier {

  Future<bool> saveToken(TokenModel user) async {

    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('token', user.token.toString()); 
    notifyListeners();
    return true;
  }

  Future<TokenModel> getToken() async {

    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? token = sp.getString('token');
    return TokenModel(
      token: token.toString()
    );
  }

  Future<bool> remove() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove('token');
    return true;
  } 
}
