import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:my_portfolio_app/models/portfolio_model.dart';

class PortfolioService {
  static const String baseUrl = "http://192.168.1.7:5144/portfolios";

  Future<List<Portfolio>> fetchPortfolios() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((json) => Portfolio.fromJson(json)).toList();
      } else if (response.statusCode == 400) {
        throw Exception("Invalid request. Please check your input.");
      } else if (response.statusCode == 404) {
        throw Exception("Portfolios not found.");
      } else if (response.statusCode >= 500) {
        throw Exception("Server error. Please try again later.");
      } else {
        throw Exception(
          "Unexpected error: ${response.statusCode} | ${response.body}",
        );
      }
    } on SocketException {
      throw Exception("No internet connection. Please check your network.");
    } catch (e) {
      throw Exception("Failed to fetch portfolios: $e");
    }
  }

  Future<Portfolio> addPortfolio(Portfolio portfolio) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(portfolio.toJson()),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);

        return Portfolio.fromJson(data);
      } else if (response.statusCode == 400) {
        throw Exception("Validation error. Please check your input.");
      } else if (response.statusCode >= 500) {
        throw Exception("Server error. Please try again later.");
      } else {
        throw Exception(
          "Unexpected error: ${response.statusCode} ${response.body}",
        );
      }
    } on SocketException {
      throw Exception("No internet connection. Please check your network.");
    } catch (e) {
      throw Exception('Failed to add portfolio: $e');
    }
  }

  Future<String> uploadImage(File imageFile) async {
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse("$baseUrl/uploads"),
      );

      request.files.add(
        await http.MultipartFile.fromPath("image", imageFile.path),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final json = jsonDecode(responseData);

        return json['url']; // URL file dari server
      }
      if (response.statusCode == 400) {
        throw Exception("Validation error. Please check your input.");
      } else if (response.statusCode == 404) {
        throw Exception("Portfolios not found.");
      } else if (response.statusCode >= 500) {
        throw Exception("Server error. Please try again later.");
      } else {
        throw Exception("Unexpected error: ${response.statusCode}");
      }
    } on SocketException {
      throw Exception("No internet connection. Please check your network.");
    } catch (e) {
      throw Exception("Failed to upload image: $e");
    }
  }

  Future<void> updatePortfolio(Portfolio portfolio) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${portfolio.id}'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(portfolio.toJson()),
      );

      if (response.statusCode != 200) {
        if (response.statusCode == 400) {
          throw Exception("Validation error. Please check your input.");
        } else if (response.statusCode == 404) {
          throw Exception("Portfolios not found.");
        } else if (response.statusCode >= 500) {
          throw Exception("Server error. Please try again later.");
        } else {
          throw Exception(
            'Unexpected error: ${response.statusCode} | ${response.body}',
          );
        }
      }
    } on SocketException {
      throw Exception("No internet connection. Please check your network.");
    } catch (e) {
      throw Exception("Failed to update portfolio: $e");
    }
  }

  Future<void> deletePortfolio(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 200) {
        throw Exception(
          'Unexpected error: ${response.statusCode} | ${response.body}',
        );
      }
    } on SocketException {
      throw Exception("No internet connection. Please check your network.");
    } catch (e) {
      throw Exception("Failed to delete portfolio: $e");
    }
  }
}
