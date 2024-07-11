// lib/constants.dart

class ApiConstants {
  static const String baseUrl =
      'https://zodiacjewerlyswd.azurewebsites.net/api';
  static const String authenticationEndpoint = '$baseUrl/authentication';
  static const String loginEndpoint = '$baseUrl/authentication/login';
  static const String getProductEndpoint = '$baseUrl/products';
  static const String deleteProductInCartEndpoint = '$baseUrl/orders/remove-product';
  static const String getProductInCartEndpoint = '$baseUrl/orders/customer';
  static const String updateQuantityEndpoint = '$baseUrl/orders/update-quantity';
  static const String getUserInfoEndpoint = '$baseUrl/users';
  static const int defaultPageSize = 50; // Default page size
}
