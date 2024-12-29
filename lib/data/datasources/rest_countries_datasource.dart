import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:countries_app/data/datasources/country_datasource.dart';
import 'package:countries_app/models/country.dart';
import 'package:http/http.dart' as http;

class RestCountriesDataSource implements CountryDataSource {
  static const String baseUrl = 'https://restcountries.com/v3.1/region/Americas';

  @override
  Future<List<Country>> getCountries() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw TimeoutException('La conexión ha excedido el tiempo de espera');
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => _parseCountry(json)).toList();
      } else {
        throw HttpException(
          'Error al cargar países: ${response.statusCode} - ${response.body}',
        );
      }
    } on TimeoutException catch (e) {
      throw Exception('Tiempo de espera agotado: $e');
    } on SocketException catch (e) {
      throw Exception('Error de conexión: $e');
    } on HttpException catch (e) {
      throw Exception('Error HTTP: $e');
    } catch (e) {
      throw Exception('Error al obtener países: $e');
    }
  }

  Country _parseCountry(Map<String, dynamic> json) {
    try {
      return Country(
        name: json['name']['common'] ?? 'Unknown',
        capital: (json['capital'] as List?)?.firstOrNull ?? 'N/A',
        region: json['region'] ?? 'Unknown',
        flag: json['flags']?['png'] ?? 'https://via.placeholder.com/150',
        population: json['population'] ?? 0,
      );
    } catch (e) {
      print('Error parsing country: $e');
      rethrow;
    }
  }
}
