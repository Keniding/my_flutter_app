import 'package:countries_app/data/datasources/rest_countries_datasource.dart';
import 'package:countries_app/data/repositories/country_repository_impl.dart';
import 'package:countries_app/models/country.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:countries_app/providers/country_provider.dart';
import 'package:countries_app/screens/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CountryAdapter());
  final countriesBox = await Hive.openBox<Country>('countries');

  final countryRepository = CountryRepositoryImpl(
    remoteDataSource: RestCountriesDataSource(),
    localStorage: countriesBox,
  );
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => CountryProvider(repository: countryRepository),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countries Explorer',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ).copyWith(
          secondary: const Color(0xFF03DAC6),
          tertiary: const Color(0xFFFF8A65),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1C1B1F),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF49454F),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}