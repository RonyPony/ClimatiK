import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/weather_mapper.dart';
import '../../controllers/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(homeWeatherProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Climatik'), actions: [IconButton(onPressed: ()=>context.push('/cities'), icon: const Icon(Icons.location_city)), IconButton(onPressed: ()=>context.push('/settings'), icon: const Icon(Icons.settings))]),
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: ElevatedButton(onPressed: ()=>ref.invalidate(homeWeatherProvider), child: Text('Reintentar: $e'))),
        data: (v) {
          final list = v.forecast.dataSeries.take(8).toList();
          final current = list.first;
          return RefreshIndicator(onRefresh: () async => ref.invalidate(homeWeatherProvider), child: ListView(padding: const EdgeInsets.all(16), children: [
            Text(v.city.name, style: Theme.of(context).textTheme.headlineMedium),
            Text('${current.temp2m}°', style: Theme.of(context).textTheme.displayLarge),
            Card(child: Padding(padding: const EdgeInsets.all(16), child: Text('${WeatherMapper.precipLabel(current.precType)} · ${WeatherMapper.cloudLabel(current.cloudcover)}'))),
            SizedBox(height: 220, child: LineChart(LineChartData(lineBarsData: [LineChartBarData(spots: List.generate(list.length, (i)=>FlSpot(i.toDouble(), list[i].temp2m.toDouble())), isCurved: true)]))),
            SizedBox(height: 130, child: ListView.separated(scrollDirection: Axis.horizontal, itemBuilder: (_,i){final p=list[i];final t=WeatherMapper.pointTime(v.forecast.init,p.timepoint);return Card(child: SizedBox(width: 110, child: Padding(padding: const EdgeInsets.all(10), child: Column(mainAxisAlignment: MainAxisAlignment.center, children:[Text('${t.hour}:00'),Text('${p.temp2m}°'),Text(p.wind.direction)]))));}, separatorBuilder: (_,__)=>const SizedBox(width: 8), itemCount: list.length))
          ]));
        },
      ),
    );
  }
}
