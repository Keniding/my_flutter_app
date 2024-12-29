import 'package:countries_app/data/repositories/country_repository.dart';
import 'package:countries_app/models/country.dart';
import 'package:flutter/foundation.dart';

class CountryProvider with ChangeNotifier {
  final CountryRepository _repository;
  
  CountryProvider({
    required CountryRepository repository,
  }) : _repository = repository;

  List<Country> _countries = [];
  bool _isLoading = false;
  String _error = '';

  List<Country> get countries => _countries;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchCountries() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // Primero intentamos obtener datos en caché
      final cachedData = _repository.getCachedCountries();
      if (cachedData.isNotEmpty) {
        _countries = cachedData;
        notifyListeners();
      }

      // Luego intentamos obtener datos frescos
      _countries = await _repository.getCountries();
      _error = '';
    } catch (e) {
      _error = e.toString();
      // Si hay un error y no tenemos datos en caché, mostramos el error
      if (_countries.isEmpty) {
        _countries = [];
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
