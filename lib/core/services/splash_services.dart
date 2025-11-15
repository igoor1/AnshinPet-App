import 'dart:async';
import 'package:anshinpet/configs/routes/routes_name.dart';
import 'package:anshinpet/model/token_model.dart';
import 'package:anshinpet/viewmodels/token_view_model.dart';
import 'package:flutter/material.dart';

class SplashServices {

  Future<TokenModel> getUserDate() => TokenViewModel().getToken();

  void checkAuthentication(BuildContext context) async {

    TokenViewModel().getToken().then((value){

      if(value.token == 'null' || value.token == ''){
        Timer(const Duration(seconds: 3),
              ()=> 
        Navigator.pushNamed(context, RoutesName.login) );
      }else {
        Timer(Duration(seconds: 3),
              ()=> 
        Navigator.pushNamed(context, RoutesName.home));
      }
    }).onError((error, stackTrace){
      Timer(Duration(seconds: 3),
            ()=> 
        Navigator.pushNamed(context, RoutesName.login));
    });
  }
}