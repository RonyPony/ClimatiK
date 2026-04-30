import "package:flutter/material.dart";
enum WeatherMood { sunny, cloudy, rainy, night, stormy, clear }

class WindInfo {
  const WindInfo({required this.direction, required this.speed});
  final String direction;
  final int speed;
}

class WeatherPoint {
  const WeatherPoint({
    required this.timepoint,
    required this.cloudcover,
    required this.seeing,
    required this.transparency,
    required this.liftedIndex,
    required this.rh2m,
    required this.wind,
    required this.temp2m,
    required this.precType,
  });
  final int timepoint;
  final int cloudcover;
  final int seeing;
  final int transparency;
  final int liftedIndex;
  final int rh2m;
  final WindInfo wind;
  final int temp2m;
  final String precType;
}

class WeatherForecast {
  const WeatherForecast({required this.product, required this.init, required this.dataSeries});
  final String product;
  final String init;
  final List<WeatherPoint> dataSeries;
}

class City {
  const City({required this.name, required this.lat, required this.lon});
  final String name;
  final double lat;
  final double lon;
}

class UserSession {
  const UserSession({required this.email, required this.name, required this.loggedIn});
  final String email;
  final String name;
  final bool loggedIn;
}

class AppSettings {
  const AppSettings({
    required this.themeMode,
    required this.tempUnit,
    required this.windUnit,
    required this.animations,
    required this.refreshOnOpen,
  });
  final ThemeMode themeMode;
  final String tempUnit;
  final String windUnit;
  final bool animations;
  final bool refreshOnOpen;
}
