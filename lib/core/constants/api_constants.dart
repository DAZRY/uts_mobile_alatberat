class ApiConstants {
  static const String baseUrl = 'http://192.168.1.x:8081/v1';
  // Ganti IP di atas dengan IP WiFi laptopmu (cek pakai ipconfig)

  static const String verifyToken = '$baseUrl/auth/verify-token';
  static const String products    = '$baseUrl/products';
  static const String cart        = '$baseUrl/cart';
  static const String checkout    = '$baseUrl/orders/checkout';
}