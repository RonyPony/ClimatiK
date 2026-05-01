import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/weather_display_mapper.dart';
import '../../controllers/providers.dart';
import '../../widgets/weather_widgets.dart';

class CityDetailScreen extends ConsumerWidget {
  const CityDetailScreen(
      {super.key, required this.name, required this.lat, required this.lon});
  final String name;
  final double lat;
  final double lon;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(weatherRepoProvider).getWeather(lat, lon),
      builder: (_, s) {
        if (s.hasError)
          return Scaffold(
              appBar: AppBar(title: Text(name)),
              body: const Center(child: Text('Error al cargar clima')));
        if (!s.hasData)
          return Scaffold(
              appBar: AppBar(title: Text(name)),
              body: const Center(child: CircularProgressIndicator()));
        final list = s.data!.dataSeries.take(8).toList();
        double now = double.parse(DateTime.now().toString());
        final current = findClosest(
          list,
          now,
          (c) => double.parse(c.timepoint.toString()),
        );
        final mood = WeatherDisplayMapper.mood(current,
            WeatherDisplayMapper.pointDate(s.data!.init, current.timepoint));
        return Scaffold(
            appBar: AppBar(title: Text(name)),
            body: WeatherMoodBackground(
                mood: mood,
                child: ListView(padding: const EdgeInsets.all(16), children: [
                  WeatherHero(
                      temp: current.temp2m,
                      summary:
                          '${WeatherDisplayMapper.cloudText(current.cloudcover)}',
                      mood: mood),
                  SizedBox(
                      height: 160,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, i) => HourlyForecastCard(
                              point: list[i], init: s.data!.init),
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemCount: list.length)),
                  WeatherInsightCard(
                      title: 'Condiciones del cielo',
                      value:
                          '${WeatherDisplayMapper.seeing(current.seeing)} · ${WeatherDisplayMapper.transparency(current.transparency)}'),
                ])));
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
