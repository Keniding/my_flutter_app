import 'package:countries_app/models/country.dart';
import 'package:flutter/material.dart';

class CountryDetailScreen extends StatelessWidget {
  final Country country;

  const CountryDetailScreen({
    super.key,
    required this.country,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(country.name),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    country.flag,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(
                    context,
                    'Capital',
                    country.capital,
                    Icons.location_city,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    context,
                    'Region',
                    country.region,
                    Icons.public,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    context,
                    'Population',
                    '${country.population.toString()} people',
                    Icons.people,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: const ColorFilter.mode(
            Colors.white,
            BlendMode.overlay,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}