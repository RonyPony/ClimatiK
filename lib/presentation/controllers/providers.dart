import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/weather_api_service.dart';
import '../../data/models/models.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../domain/entities/entities.dart';
import '../../services/location/location_service.dart';
import '../../services/storage/local_storage_service.dart';

final dioProvider = Provider(
    (ref) => Dio(BaseOptions(connectTimeout: const Duration(seconds: 10))));
final weatherRepoProvider = Provider(
    (ref) => WeatherRepositoryImpl(WeatherApiService(ref.watch(dioProvider))));
final storageProvider = Provider((ref) => LocalStorageService());

final homeWeatherProvider =
    FutureProvider<({City city, WeatherForecast forecast})>((ref) async {
  final city = await LocationService().currentCityOrFallback();
  final forecast =
      await ref.watch(weatherRepoProvider).getWeather(city.lat, city.lon);
  return (city: city, forecast: forecast);
});

final savedCitiesProvider =
    StateNotifierProvider<SavedCitiesController, List<City>>(
        (ref) => SavedCitiesController(ref.watch(storageProvider))..load());

class SavedCitiesController extends StateNotifier<List<City>> {
  SavedCitiesController(this._storage) : super(const []);
  final LocalStorageService _storage;
  static const _k = 'cities';
  Future<void> load() async => state =
      (await _storage.readList(_k)).map((e) => CityModel.fromJson(e)).toList();
  Future<void> add(City city) async {
    state = [...state, city];
    await _storage.writeList(
        _k,
        state
            .map(
                (e) => CityModel(name: e.name, lat: e.lat, lon: e.lon).toJson())
            .toList());
  }

  Future<void> clear() async {
    state = [];
    await _storage.remove(_k);
  }

  Future<void> remove(String name) async {
    state = [];
    await _storage.remove(name);
  }
}
