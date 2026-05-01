import 'package:climatik/core/utils/weather_display_mapper.dart';
import 'package:climatik/presentation/widgets/weather_widgets.dart';
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
    return data.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
          body: Center(
              child: ElevatedButton(
                  onPressed: () => ref.invalidate(homeWeatherProvider),
                  child: Text('Reintentar: $e')))),
      data: (v) {
        int max = v.forecast.dataSeries.length;
        final listDias = v.forecast.dataSeries.take(max).toList();
        final listDiasFiltered = listDias.sublist(7, max);
        final list = v.forecast.dataSeries.take(8).toList();
        double now = double.parse(DateTime.now().hour.toString());
        final current = findClosest(
          list,
          now,
          (c) => double.parse(c.timepoint.toString()),
        );
        final mood = WeatherDisplayMapper.mood(current,
            WeatherDisplayMapper.pointDate(v.forecast.init, current.timepoint));
        return Scaffold(
          appBar: AppBar(title: const Text('Climatik'), actions: [
            IconButton(
                onPressed: () => context.push('/cities'),
                icon: const Icon(Icons.location_city)),
            IconButton(
                onPressed: () => context.push('/settings'),
                icon: const Icon(Icons.settings)),
            IconButton(
                onPressed: () => context.push('/login'),
                icon: const Icon(Icons.person))
          ]),
          body: WeatherMoodBackground(
            mood: mood,
            child: RefreshIndicator(
              onRefresh: () async => ref.invalidate(homeWeatherProvider),
              child: ListView(padding: const EdgeInsets.all(16), children: [
                Text(v.city.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700)),
                WeatherHero(
                    temp: current.temp2m,
                    summary:
                        '${WeatherDisplayMapper.cloudText(current.cloudcover)} con ${WeatherDisplayMapper.precipitation(current.precType).toLowerCase()}',
                    mood: mood),
                const SizedBox(height: 8),
                const Text('Próximas horas',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                SizedBox(
                    height: 160,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, i) => HourlyForecastCard(
                            point: list[i], init: v.forecast.init),
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemCount: list.length)),
                const SizedBox(height: 8),
                const Text('Próximos dias',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                SizedBox(
                    height: 160,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, i) => HourlyForecastCard(
                            point: listDiasFiltered[i], init: v.forecast.init),
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemCount: listDiasFiltered.length)),
                WeatherInsightCard(
                    title: 'Qué esperar',
                    value:
                        '${WeatherDisplayMapper.precipitation(current.precType)} durante las próximas horas, con ${WeatherDisplayMapper.windText(current.wind.speed).toLowerCase()} desde ${current.wind.direction}.'),
                WeatherInsightCard(
                    title: 'Condiciones del cielo',
                    value:
                        '${WeatherDisplayMapper.cloudText(current.cloudcover)}. Visibilidad del cielo ${WeatherDisplayMapper.seeing(current.seeing)} y ${WeatherDisplayMapper.transparency(current.transparency).toLowerCase()}.'),
                WeatherInsightCard(
                    title: 'Viento y humedad',
                    value:
                        '${WeatherDisplayMapper.windText(current.wind.speed)} del ${current.wind.direction}. ${WeatherDisplayMapper.humidity(current.rh2m)}.'),
              ]),
            ),
          ),
        );
      },
    );
  }
}

T findClosest<T>(
  List<T> items,
  double target,
  double Function(T item) selector,
) {
  T closest = items.first;
  double minDiff = (selector(closest) - target).abs();

  for (final item in items) {
    final value = selector(item);
    final diff = (value - target).abs();

    if (diff < minDiff) {
      minDiff = diff;
      closest = item;
    }
  }

  return closest;
}
