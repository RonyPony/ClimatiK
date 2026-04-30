import '../../domain/entities/entities.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_api_service.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl(this._api);
  final WeatherApiService _api;
  @override
  Future<WeatherForecast> getWeather(double lat, double lon) => _api.fetch(lat, lon);
}
