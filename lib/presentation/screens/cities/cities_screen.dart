import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/providers.dart';
import '../../widgets/weather_widgets.dart';

const predefinedCities = [
  City(name: 'Santo Domingo', lat: 18.4861, lon: -69.9312),
  City(name: 'Santiago', lat: 19.4517, lon: -70.6970),
  City(name: 'Punta Cana', lat: 18.5601, lon: -68.3725),
  City(name: 'La Romana', lat: 18.4273, lon: -68.9728),
  City(name: 'Nueva York', lat: 40.7128, lon: -74.0060),
  City(name: 'Miami', lat: 25.7617, lon: -80.1918),
  City(name: 'Madrid', lat: 40.4168, lon: -3.7038),
];

class CitiesScreen extends ConsumerStatefulWidget {
  const CitiesScreen({super.key});
  @override
  ConsumerState<CitiesScreen> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends ConsumerState<CitiesScreen> {
  String q = '';

  @override
  Widget build(BuildContext context) {
    final saved = ref.watch(savedCitiesProvider);
    final filtered = predefinedCities
        .where((c) => c.name.toLowerCase().contains(q.toLowerCase()))
        .toList();

    final selectedNames = saved.map((e) => e.name).toSet();
    final selected =
        filtered.where((c) => selectedNames.contains(c.name)).toList();
    final unselected =
        filtered.where((c) => !selectedNames.contains(c.name)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Ciudades')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            onChanged: (v) => setState(() => q = v),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Buscar ciudad',
            ),
          ),
          const SizedBox(height: 12),
          if (selected.isEmpty && unselected.isEmpty)
            const EmptyCitiesState()
          else ...[
            if (selected.isNotEmpty) ...[
              const Text('Agregadas',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ...selected.map((c) => _CityTile(city: c, isAdded: true)),
            ],
            if (selected.isNotEmpty && unselected.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1),
              ),
            ],
            if (unselected.isNotEmpty) ...[
              const Text('Disponibles',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ...unselected.map((c) => _CityTile(city: c, isAdded: false)),
            ],
          ],
        ],
      ),
    );
  }
}


class _CityTile extends ConsumerWidget {
  const _CityTile({required this.city, required this.isAdded});

  final City city;
  final bool isAdded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: Text(city.name),
        subtitle: isAdded
            ? const Text('Agregada a tus ciudades')
            : const Text('Toca + para agregarla'),
        onTap: isAdded
            ? () => context.push('/city/${city.name}/${city.lat}/${city.lon}')
            : null,
        trailing: isAdded
            ? IconButton(
                icon: const Icon(Icons.check_circle),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () =>
                    ref.read(savedCitiesProvider.notifier).remove(city.name),
              )
            : IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => ref.read(savedCitiesProvider.notifier).add(city),
              ),
      ),
    );
  }
}
