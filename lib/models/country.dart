import 'package:hive/hive.dart';

part 'country.g.dart';

@HiveType(typeId: 0)
class Country extends HiveObject {
  @HiveField(0)
  final String name;
  
  @HiveField(1)
  final String capital;
  
  @HiveField(2)
  final String region;
  
  @HiveField(3)
  final String flag;
  
  @HiveField(4)
  final int population;

  Country({
    required this.name,
    required this.capital,
    required this.region,
    required this.flag,
    required this.population,
  });
}