import 'package:flutter/material.dart';
import '../../core/utils/weather_display_mapper.dart';
import '../../domain/entities/entities.dart';

class WeatherMoodBackground extends StatelessWidget {
  const WeatherMoodBackground(
      {super.key, required this.mood, required this.child});
  final WeatherMood mood;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final colors = switch (mood) {
      WeatherMood.rainy => [const Color(0xFF1F2937), const Color(0xFF334155)],
      WeatherMood.stormy => [const Color(0xFF111827), const Color(0xFF1E3A8A)],
      WeatherMood.cloudy => [const Color(0xFF475569), const Color(0xFF64748B)],
      WeatherMood.night => [const Color(0xFF0B1026), const Color(0xFF1E1B4B)],
      _ => [const Color(0xFF0EA5E9), const Color(0xFFF59E0B)]
    };
    return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: child);
  }
}

class WeatherHero extends StatelessWidget {
  const WeatherHero(
      {super.key,
      required this.temp,
      required this.summary,
      required this.mood});
  final int temp;
  final String summary;
  final WeatherMood mood;
  @override
  Widget build(BuildContext context) => Card(
      color: Colors.white.withValues(alpha: .15),
      child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(children: [
            Icon(WeatherDisplayMapper.moodIcon(mood),
                size: 64, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('$temp°C',
                      style: const TextStyle(
                          fontSize: 50,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  Text(summary, style: const TextStyle(color: Colors.white))
                ]))
          ])));
}

class HourlyForecastCard extends StatelessWidget {
  const HourlyForecastCard(
      {super.key, required this.point, required this.init});
  final WeatherPoint point;
  final String init;
  @override
  Widget build(BuildContext context) {
    final t = WeatherDisplayMapper.hourLabel(init, point.timepoint);
    final mood = WeatherDisplayMapper.mood(
        point, WeatherDisplayMapper.pointDate(init, point.timepoint));
    return Card(
        color: Colors.white.withValues(alpha: .15),
        child: SizedBox(
            width: 160,
            child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(WeatherDisplayMapper.moodIcon(mood),
                          color: Colors.white),
                      Text(t,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12)),
                      Text('${point.temp2m}°C',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      Text(WeatherDisplayMapper.precipitation(point.precType),
                          style: const TextStyle(color: Colors.white)),
                      Text(
                          '${WeatherDisplayMapper.windText(point.wind.speed)} · ${point.wind.direction}',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12))
                    ]))));
  }
}

class WeatherInsightCard extends StatelessWidget {
  const WeatherInsightCard(
      {super.key, required this.title, required this.value});
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) =>
      Card(child: ListTile(title: Text(title), subtitle: Text(value)));
}

class EmptyCitiesState extends StatelessWidget {
  const EmptyCitiesState({super.key});
  @override
  Widget build(BuildContext context) => const Padding(
      padding: EdgeInsets.all(24),
      child: Center(child: Text('Agrega una ciudad para ver su clima aquí.')));
}
