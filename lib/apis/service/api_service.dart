import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/image_data.dart';


class ApiService {
  final String _apiKey = "45934804-2a2797f1568b2ac834b068bc1" ?? '';
  final String _baseUrl = "https://pixabay.com/api/" ?? '';


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
