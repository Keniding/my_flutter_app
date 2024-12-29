import 'package:countries_app/models/country.dart';

abstract class CountryRepository {
  Future<List<Country>> getCountries();
  Future<void> saveCountries(List<Country> countries);
  List<Country> getCachedCountries();
}