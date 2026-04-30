import '../entities/entities.dart';

abstract class WeatherRepository {
  Future<WeatherForecast> getWeather(double lat, double lon);
}
