import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/providers.dart';

class CityDetailScreen extends ConsumerWidget {
  const CityDetailScreen({super.key, required this.name, required this.lat, required this.lon});
  final String name; final double lat; final double lon;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(future: ref.read(weatherRepoProvider).getWeather(lat, lon), builder: (_, s) {
      if (!s.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));
      final w = s.data!;
      return Scaffold(appBar: AppBar(title: Text(name)), body: ListView(children: w.dataSeries.take(16).map((p)=>ListTile(title: Text('${p.temp2m}°C'), subtitle: Text('${p.precType} · ${p.wind.direction}-${p.wind.speed}'))).toList()));
    });
  }
}
