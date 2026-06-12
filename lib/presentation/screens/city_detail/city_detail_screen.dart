import 'package:climatik/core/utils/weather_display_mapper.dart';
import 'package:climatik/presentation/widgets/weather_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/providers.dart';

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
        if (s.hasError) {
          return Scaffold(
              appBar: AppBar(title: Text(name)),
              body: const Center(child: Text('Error al cargar clima')));
        }
        if (!s.hasData) {
          return Scaffold(
              appBar: AppBar(title: Text(name)),
              body: const Center(child: CircularProgressIndicator()));
        }
        final list = s.data!.dataSeries.take(8).toList();
        final now = DateTime.now();
        final current = findClosestDateTime(
          list,
          now,
          (c) => WeatherDisplayMapper.pointDate(s.data!.init, c.timepoint),
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
                          WeatherDisplayMapper.cloudText(current.cloudcover),
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

T findClosestDateTime<T>(
  List<T> items,
  DateTime target,
  DateTime Function(T item) selector,
) {
  T closest = items.first;
  var minDiff = selector(closest).difference(target).inMinutes.abs();

  for (final item in items) {
    final value = selector(item);
    final diff = value.difference(target).inMinutes.abs();

    if (diff < minDiff) {
      minDiff = diff;
      closest = item;
    }
  }

  return closest;
}
