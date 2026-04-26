import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uts_mobile_alatberat/core/constants/api_constants.dart';

class AuthRepository {
  Future<Map<String, dynamic>> verifyTokenWithBackend(String firebaseToken) async {
    final response = await http.post(
      Uri.parse(ApiConstants.verifyToken),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'firebase_token': firebaseToken}),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 && body['success'] == true) {
      return body['data'];
    } else if (body['error_code'] == 'EMAIL_NOT_VERIFIED') {
      throw Exception('EMAIL_NOT_VERIFIED');
    } else {
      throw Exception(body['message'] ?? 'Gagal verifikasi token');
    }
  }
}