import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PhotoApiProvider with ChangeNotifier {
  List<Map<String, dynamic>> _photos = [];

  List<Map<String, dynamic>> get photos => _photos;

  Future<void> fetchPhotos() async {
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
      if (response.statusCode == 200) {
        _photos = List<Map<String, dynamic>>.from(json.decode(response.body));
        notifyListeners();
      } else {
        throw Exception('Failed to load photos');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createPhotoApi(String title, String url, String thumbnailUrl, int albumId) async {
    try {
      final response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/photos'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': title,
          'url': url,
          'thumbnailUrl': thumbnailUrl,
          'albumId': albumId,
        }),
      );

      if (response.statusCode == 201) {
        final newPhoto = json.decode(response.body);
        _photos.add(newPhoto);
        notifyListeners();
        return {'success': true, 'statusCode': response.statusCode};
      } else {
        return {'success': false, 'statusCode': response.statusCode};
      }
    } catch (error) {
      return {'success': false, 'statusCode': 500, 'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> updatePhotoApi(int id, String title, String url, String thumbnailUrl, int albumId) async {
    try {
      final response = await http.put(
        Uri.parse('https://jsonplaceholder.typicode.com/photos/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': title,
          'url': url,
          'thumbnailUrl': thumbnailUrl,
          'albumId': albumId,
        }),
      );

      if (response.statusCode == 200) {
        final updatedPhoto = json.decode(response.body);
        final index = _photos.indexWhere((photo) => photo['id'] == id);
        if (index != -1) {
          _photos[index] = updatedPhoto;
          notifyListeners();
        }
        return {'success': true, 'statusCode': response.statusCode};
      } else {
        return {'success': false, 'statusCode': response.statusCode};
      }
    } catch (error) {
      return {'success': false, 'statusCode': 500, 'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> deletePhotoApi(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('https://jsonplaceholder.typicode.com/photos/$id'),
      );

      if (response.statusCode == 200) {
        _photos.removeWhere((photo) => photo['id'] == id);
        notifyListeners();
        return {'success': true, 'statusCode': response.statusCode};
      } else {
        return {'success': false, 'statusCode': response.statusCode};
      }
    } catch (error) {
      return {'success': false, 'statusCode': 500, 'error': error.toString()};
    }
  }
}
