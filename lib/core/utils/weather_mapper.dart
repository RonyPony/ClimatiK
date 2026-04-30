import 'package:intl/intl.dart';
import '../../domain/entities/entities.dart';

class WeatherMapper {
  static WeatherMood moodFrom(WeatherPoint point, DateTime time) {
    final hour = time.hour;
    if (hour >= 19 || hour <= 5) return WeatherMood.night;
    if (point.liftedIndex <= -4 && point.precType == 'rain')
      return WeatherMood.stormy;
    if (point.precType == 'rain') return WeatherMood.rainy;
    if (point.cloudcover >= 6) return WeatherMood.cloudy;
    if (point.cloudcover <= 2 && point.precType == 'none')
      return WeatherMood.clear;
    return WeatherMood.sunny;
  }

  static DateTime parseInit(String init) {
    return DateTime.utc(
      int.parse(init.substring(0, 4)),
      int.parse(init.substring(4, 6)),
      int.parse(init.substring(6, 8)),
      int.parse(init.substring(8, 10)),
    ).toLocal();
  }

  static DateTime pointTime(String init, int timepoint) =>
      parseInit(init).add(Duration(hours: timepoint));
  static String cloudLabel(int c) => c <= 2
      ? 'Despejado'
      : c <= 5
          ? 'Parcial'
          : 'Nublado';
  static String humidityLabel(int h) => h < 40
      ? 'Seca'
      : h < 70
          ? 'Confortable'
          : 'Húmeda';
  static String windLabel(int s) => s <= 2
      ? 'Ligero'
      : s <= 5
          ? 'Moderado'
          : 'Fuerte';
  static String precipLabel(String p) =>
      p == 'rain' ? 'Lluvia' : 'Sin precipitación';
}
