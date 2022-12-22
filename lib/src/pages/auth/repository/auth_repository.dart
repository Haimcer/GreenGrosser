import 'package:greengrosser/src/constants/endpoints.dart';
import 'package:greengrosser/src/models/user_model.dart';
import 'package:greengrosser/src/pages/auth/repository/auth_errors.dart'
    as authErrors;
import 'package:greengrosser/src/pages/auth/result/auth_result.dart';
import 'package:greengrosser/src/services/http_manager.dart';

class AuthRepository {
  final HttpManeger _httpManeger = HttpManeger();

  Future<AuthResult> validateToken(String token) async {
    final result = await _httpManeger.restRequest(
        url: Endpoints.validateToken,
        method: HttpMethods.post,
        headers: {
          'X-Parse-Session-Token': token,
        });

    if (result['result'] != null) {
      final user = UserModel.fromJson(result['result']);

      return AuthResult.success(user);
    } else {
      return AuthResult.error(authErrors.authErrorsString(result['error']));
    }
  }

  Future<AuthResult> singnIn(
      {required String email, required String password}) async {
    final result = await _httpManeger
        .restRequest(url: Endpoints.signin, method: HttpMethods.post, body: {
      'email': email,
      'password': password,
    });

    if (result["result"] != null) {
      final user = UserModel.fromJson(result['result']);

      return AuthResult.success(user);
    } else {
      return AuthResult.error(authErrors.authErrorsString(result['error']));
    }
  }
}
