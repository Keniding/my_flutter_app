import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:countries_app/data/datasources/country_datasource.dart';
import 'package:countries_app/models/country.dart';
import 'package:http/http.dart' as http;

class RestCountriesDataSource implements CountryDataSource {
  static const String baseUrl = 'https://restcountries.com/v3.1/region';
  final List<String> regions = [
    'Americas', 
    'Europe', 
    'Asia', 
    'Africa', 
    'Oceania',
    'Antarctic'
    ];

  // Cambiamos el método para que devuelva un Stream
  Stream<List<Country>> getCountriesStream() async* {
    for (final region in regions) {
      try {
        final countries = await _getCountriesByRegion(region);
        yield countries; // Emite los países de cada región conforme se obtienen
      } catch (e) {
        print('Error cargando región $region: $e');
        // Continuamos con la siguiente región si hay error
        continue;
      }
    }
  }

  // Método original modificado para cargar por región
  Future<List<Country>> _getCountriesByRegion(String region) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$region'),
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 30), // Reducimos el timeout por región
        onTimeout: () {
          throw TimeoutException(
            'La conexión ha excedido el tiempo de espera para la región $region'
          );
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => _parseCountry(json)).toList();
      } else {
        throw HttpException(
          'Error al cargar países de $region: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error al obtener países de $region: $e');
    }
  }

  // Mantenemos el método original para compatibilidad
  @override
  Future<List<Country>> getCountries() async {
    List<Country> allCountries = [];
    
    await for (final countries in getCountriesStream()) {
      allCountries.addAll(countries);
    }
    
    return allCountries;
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
