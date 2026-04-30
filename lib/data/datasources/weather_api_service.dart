import 'dart:convert';

import 'package:dio/dio.dart';
import '../models/models.dart';

class WeatherApiService {
  WeatherApiService(this._dio);
  final Dio _dio;

  Future<WeatherForecastModel> fetch(double lat, double lon) async {
    final response = await _dio
        .get('https://www.7timer.info/bin/astro.php', queryParameters: {
      'lon': lon,
      'lat': lat,
      'ac': 0,
      'unit': 'metric',
      'output': 'json',
      'tzshift': 0,
    });
    print(response.data);
    Map<String, dynamic> dd = jsonDecode(response.data);
    return WeatherForecastModel.fromJson(dd);
  }
}
