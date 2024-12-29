import 'package:countries_app/models/country.dart';

abstract class CountryDataSource {
  Future<List<Country >> getCountries();
}