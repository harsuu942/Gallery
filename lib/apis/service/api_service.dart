import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../models/image_data.dart';


class ApiService {
  final String _apiKey = dotenv.env['API_KEY'] ?? '';
  final String _baseUrl = dotenv.env['BASE_URL'] ?? '';


  Future<List<ImageData>> fetchImages({String query = '', int page = 1}) async {
    if (_apiKey.isEmpty || _baseUrl.isEmpty) {
      throw Exception('API Key or Base URL is not provided.'); // Early error if credentials are missing
    }

    try {
      final uri = Uri.parse(_baseUrl);
      final response = await http.get(
        Uri.https(uri.host, uri.path, {'key': _apiKey, 'q': query, 'page': '$page'}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData.containsKey('hits')) {
          return (jsonData['hits'] as List)
              .map((item) => ImageData.fromJson(item))
              .toList();
        } else {
          throw Exception('Invalid API response format: Missing "hits" key.');
        }
      } else {
        throw Exception('Failed to load images: ${response.statusCode}');
      }
    } catch (e) {

      rethrow;
    }
  }
}
