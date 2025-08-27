import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JwtHelper {
  static String sign(Map<String, dynamic> payload, String secret) {
    final jwt = JWT(payload);

    final token = jwt.sign(SecretKey(secret));
    return token;
  }

  static Map<String, dynamic>? verify(String token, String secret) {
    final jwt = JWT.verify(token, SecretKey(secret));
    return jwt.payload;
  }

  static Map<String, dynamic>? decodeJwt(String token) {
    final jwt = JWT.decode(token);
    return jwt.payload;
  }
}
