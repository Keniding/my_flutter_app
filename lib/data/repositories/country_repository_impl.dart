import 'package:countries_app/data/datasources/country_datasource.dart';
import 'package:countries_app/data/repositories/country_repository.dart';
import 'package:countries_app/models/country.dart';
import 'package:hive/hive.dart';

class CountryRepositoryImpl implements CountryRepository {
  final CountryDataSource remoteDataSource;
  final Box<Country> localStorage;

  CountryRepositoryImpl({
    required this.remoteDataSource,
    required this.localStorage,
  });

  @override
  Future<List<Country>> getCountries() async {
    try {
      final countries = await remoteDataSource.getCountries();
      await saveCountries(countries);
      return countries;
    } catch (e) {
      // Si falla la API, intentamos devolver datos en caché
      final cachedCountries = getCachedCountries();
      if (cachedCountries.isNotEmpty) {
        return cachedCountries;
      }
      rethrow;
    }
  }

  @override
  Future<void> saveCountries(List<Country> countries) async {
    await localStorage.clear();
    await localStorage.addAll(countries);
  }

  @override
  List<Country> getCachedCountries() {
    return localStorage.values.toList();
  }
}