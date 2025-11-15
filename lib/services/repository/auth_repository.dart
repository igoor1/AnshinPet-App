import 'package:anshinpet/services/network/BaseApiServices.dart';
import 'package:anshinpet/services/network/NetworkApiService.dart';
import 'package:anshinpet/configs/app_url.dart';
import 'package:anshinpet/model/token_model.dart';

class AuthRepository {

  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> loginApi(dynamic data) async {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.loginUrl, data);
      return TokenModel.fromJson(response);
    }
}