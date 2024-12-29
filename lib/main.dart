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
          seedColor: const Color(0xFF1E88E5), // Azul profundo
          brightness: Brightness.light,
        ).copyWith(
          secondary: const Color(0xFF42A5F5),
          tertiary: const Color(0xFF90CAF9),
          surface: Colors.white.withOpacity(0.9),
        ),
        // Configuración para efectos de cristal
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A237E),
            letterSpacing: -0.5,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF37474F),
            letterSpacing: 0.5,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}