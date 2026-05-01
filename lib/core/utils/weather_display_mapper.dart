import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/entities.dart';

class WeatherDisplayMapper {
  static final Map<int, String> _cloud = {
    1: 'Cielo despejado',
    2: 'Casi despejado',
    3: 'Poco nublado',
    4: 'Parcialmente nublado',
    5: 'Nubes dispersas',
    6: 'Mayormente nublado',
    7: 'Nublado',
    8: 'Muy nublado',
    9: 'Cubierto'
  };
  static final Map<int, String> _wind = {
    1: 'Viento en calma',
    2: 'Brisa ligera',
    3: 'Viento moderado',
    4: 'Viento fresco',
    5: 'Viento fuerte',
    6: 'Temporal',
    7: 'Tormenta',
    8: 'Huracán'
  };
  static final Map<String, String> _prec = {
    'none': 'Sin lluvia',
    'rain': 'Lluvia',
    'snow': 'Nieve',
    'frzr': 'Lluvia helada',
    'icep': 'Granizo o hielo'
  };

  static String cloudText(int v) => _cloud[v] ?? 'Estado variable';
  static String windText(int v) => _wind[v] ?? 'Viento variable';
  static String precipitation(String v) => _prec[v] ?? 'Sin lluvia';
  static String humidity(int v) => v <= 5
      ? 'Humedad baja'
      : v <= 10
          ? 'Humedad media'
          : 'Ambiente húmedo';
  static String seeing(int v) => v <= 2
      ? 'Excelente'
      : v <= 4
          ? 'Buena'
          : v <= 6
              ? 'Regular'
              : 'Pobre';
  static String transparency(int v) => v <= 2
      ? 'Claridad alta'
      : v <= 4
          ? 'Claridad buena'
          : v <= 6
              ? 'Claridad media'
              : 'Claridad baja';
  static String instability(WeatherPoint p) => p.liftedIndex <= -6
      ? 'Alta inestabilidad'
      : p.liftedIndex <= -4
          ? 'Posible tormenta'
          : p.liftedIndex <= -1
              ? 'Inestable'
              : 'Estable';
  static DateTime parseInitUtc(String init) {
    return DateTime.utc(
      int.parse(init.substring(0, 4)),
      int.parse(init.substring(4, 6)),
      int.parse(init.substring(6, 8)),
      int.parse(init.substring(8, 10)),
    ).toLocal();
  }

  static DateTime pointDate(String init, int tp) =>
      parseInitUtc(init).add(Duration(hours: tp)).toLocal();
  static String hourLabel(String init, int tp) {
    final d = pointDate(init, tp);
    final now = DateTime.now();
    final day = d.day == now.day
        ? 'Hoy'
        : d.day == now.add(const Duration(days: 1)).day
            ? 'Mañana'
            : DateFormat('EEE', 'es').format(d);
    return '$day ${DateFormat('h:mm a', 'es').format(d)}';
  }

  static WeatherMood mood(WeatherPoint p, DateTime t) {
    if (t.hour >= 19 || t.hour <= 5) return WeatherMood.night;
    if (p.liftedIndex <= -4 && p.precType == 'rain') return WeatherMood.stormy;
    if (p.precType == 'rain') return WeatherMood.rainy;
    if (p.cloudcover >= 7) return WeatherMood.cloudy;
    if (p.cloudcover <= 2 && p.precType == 'none') return WeatherMood.clear;
    return WeatherMood.sunny;
  }

  static IconData moodIcon(WeatherMood m) => switch (m) {
        WeatherMood.rainy => Icons.cloudy_snowing,
        WeatherMood.stormy => Icons.thunderstorm,
        WeatherMood.cloudy => Icons.cloud,
        WeatherMood.night => Icons.nightlight_round,
        WeatherMood.clear => Icons.wb_sunny,
        WeatherMood.sunny => Icons.wb_sunny_outlined
      };
}
