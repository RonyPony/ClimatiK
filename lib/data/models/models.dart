import 'package:flutter/material.dart';
import '../../domain/entities/entities.dart';

class WindInfoModel extends WindInfo {
  const WindInfoModel({required super.direction, required super.speed});
  factory WindInfoModel.fromJson(Map<String, dynamic> json) => WindInfoModel(
        direction: (json['direction'] ?? 'N').toString(),
        speed: (json['speed'] ?? 0) as int,
      );
  Map<String, dynamic> toJson() => {'direction': direction, 'speed': speed};
}

class WeatherPointModel extends WeatherPoint {
  const WeatherPointModel({
    required super.timepoint,
    required super.cloudcover,
    required super.seeing,
    required super.transparency,
    required super.liftedIndex,
    required super.rh2m,
    required super.wind,
    required super.temp2m,
    required super.precType,
  });
  factory WeatherPointModel.fromJson(Map<String, dynamic> json) => WeatherPointModel(
        timepoint: (json['timepoint'] ?? 0) as int,
        cloudcover: (json['cloudcover'] ?? 0) as int,
        seeing: (json['seeing'] ?? 0) as int,
        transparency: (json['transparency'] ?? 0) as int,
        liftedIndex: (json['lifted_index'] ?? 0) as int,
        rh2m: (json['rh2m'] ?? 0) as int,
        wind: WindInfoModel.fromJson((json['wind10m'] ?? {}) as Map<String, dynamic>),
        temp2m: (json['temp2m'] ?? 0) as int,
        precType: (json['prec_type'] ?? 'none').toString(),
      );
}

class WeatherForecastModel extends WeatherForecast {
  const WeatherForecastModel({required super.product, required super.init, required super.dataSeries});
  factory WeatherForecastModel.fromJson(Map<String, dynamic> json) => WeatherForecastModel(
        product: (json['product'] ?? '').toString(),
        init: (json['init'] ?? '').toString(),
        dataSeries: ((json['dataseries'] ?? []) as List)
            .map((e) => WeatherPointModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class CityModel extends City {
  const CityModel({required super.name, required super.lat, required super.lon});
  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        name: json['name'] as String,
        lat: (json['lat'] as num).toDouble(),
        lon: (json['lon'] as num).toDouble(),
      );
  Map<String, dynamic> toJson() => {'name': name, 'lat': lat, 'lon': lon};
}

class UserSessionModel extends UserSession {
  const UserSessionModel({required super.email, required super.name, required super.loggedIn});
  factory UserSessionModel.fromJson(Map<String, dynamic> json) => UserSessionModel(
        email: json['email'] as String,
        name: json['name'] as String,
        loggedIn: json['loggedIn'] as bool,
      );
  Map<String, dynamic> toJson() => {'email': email, 'name': name, 'loggedIn': loggedIn};
}

class AppSettingsModel extends AppSettings {
  const AppSettingsModel({
    required super.themeMode,
    required super.tempUnit,
    required super.windUnit,
    required super.animations,
    required super.refreshOnOpen,
  });
  factory AppSettingsModel.defaults() => const AppSettingsModel(
        themeMode: ThemeMode.system,
        tempUnit: 'C',
        windUnit: 'km/h',
        animations: true,
        refreshOnOpen: true,
      );
}
