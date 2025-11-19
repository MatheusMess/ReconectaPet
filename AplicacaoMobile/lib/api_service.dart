import 'dart:convert';
import 'package:http/http.dart' as http;
import 'autenticacao.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.15.16:8000/api';
  static final AuthService _authService = AuthService();

  static Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final token = _authService.token;
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  static Future<http.Response> get(String endpoint) async {
    try {
      print('🌐 GET: $baseUrl/$endpoint');

      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _headers,
      );

      print('📡 Status: ${response.statusCode}');
      return _handleResponse(response);
    } catch (e) {
      print('❌ Erro GET: $e');
      throw Exception('Erro na requisição: $e');
    }
  }

  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      print('🌐 POST: $baseUrl/$endpoint');
      print('📦 Data: $data');

      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _headers,
        body: json.encode(data),
      );

      print('📡 Status: ${response.statusCode}');
      print('📦 Response: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      print('❌ Erro POST: $e');
      throw Exception('Erro na requisição: $e');
    }
  }

  static Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _headers,
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }

  static Future<http.Response> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }

  static http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw Exception('Erro HTTP ${response.statusCode}: ${response.body}');
    }
  }

  // Métodos específicos para animais
  static Future<List<dynamic>> getAnimais() async {
    final response = await get('animais');
    final data = json.decode(response.body);
    return data['data'] ?? [];
  }

  static Future<dynamic> criarAnimal(Map<String, dynamic> animalData) async {
    final response = await post('animais', animalData);
    final data = json.decode(response.body);
    return data['data'];
  }

  static Future<List<dynamic>> getAnimaisPorUsuario(String userId) async {
    final response = await get('animais/user/$userId');
    final data = json.decode(response.body);
    return data['data'] ?? [];
  }

  static Future<List<dynamic>> getAnimaisPorTipo(String tipo) async {
    final response = await get('animais/tipo/$tipo');
    final data = json.decode(response.body);
    return data['data'] ?? [];
  }
}
