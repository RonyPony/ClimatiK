import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/providers.dart';
import '../../widgets/weather_widgets.dart';

const mockCities = [
  City(name: 'Santo Domingo', lat: 18.4861, lon: -69.9312),City(name: 'Santiago', lat: 19.4517, lon: -70.6970),City(name: 'Punta Cana', lat: 18.5601, lon: -68.3725),City(name: 'La Romana', lat: 18.4273, lon: -68.9728),City(name: 'Nueva York', lat: 40.7128, lon: -74.0060),City(name: 'Miami', lat: 25.7617, lon: -80.1918),City(name: 'Madrid', lat: 40.4168, lon: -3.7038),
];

class CitiesScreen extends ConsumerStatefulWidget { const CitiesScreen({super.key}); @override ConsumerState<CitiesScreen> createState()=>_CitiesScreenState(); }
class _CitiesScreenState extends ConsumerState<CitiesScreen> { String q='';
  @override Widget build(BuildContext context){ final saved=ref.watch(savedCitiesProvider); final suggestions=mockCities.where((c)=>c.name.toLowerCase().contains(q.toLowerCase())).toList();
    return Scaffold(appBar: AppBar(title: const Text('Agregar ciudad')), body: ListView(padding: const EdgeInsets.all(16), children:[
      TextField(onChanged:(v)=>setState(()=>q=v), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Buscar ciudad por nombre')),
      const SizedBox(height: 8), ...suggestions.map((c)=>Card(child:ListTile(title: Text(c.name), trailing: FilledButton(onPressed: ()=>ref.read(savedCitiesProvider.notifier).add(c), child: const Text('Agregar'))))),
      const SizedBox(height: 12), const Text('Tus ciudades', style: TextStyle(fontWeight: FontWeight.bold)),
      if(saved.isEmpty) const EmptyCitiesState(),
      ...saved.map((c)=>Card(child:ListTile(title: Text(c.name), subtitle: const Text('Pronóstico disponible'), onTap: ()=>context.push('/city/${c.name}/${c.lat}/${c.lon}'), trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: ()=>ref.read(savedCitiesProvider.notifier).remove(c.name)))))
    ]));
  }
}
