import 'package:hotpot/app/model/account.dart';

class BaseCommon {
  static BaseCommon? _instance;
  String? accessToken;
  String? refreshToken;
  String? deviceToken;
  UserAccount? account;

  BaseCommon._internal();

  static BaseCommon get instance {
    _instance ??= BaseCommon._internal();
    return _instance!;
  }

  Map<String, String> headerRequest({bool isUsingToken = true}) {
    if (isUsingToken) {
      return {
        'Content-Type': 'application/json;',
        'Accept': '*/*',
        'Authorization': 'Bearer $accessToken'
      };
    }
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json; charset=UTF-8'
    };
  }
}
