import 'package:geolocator/geolocator.dart';
import '../../domain/entities/entities.dart';

class LocationService {
  static const fallback = City(name: 'Santo Domingo', lat: 18.500847, lon: -69.778666);

  Future<City> currentCityOrFallback() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return fallback;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) return fallback;
    final pos = await Geolocator.getCurrentPosition();
    return City(name: 'Mi ubicación', lat: pos.latitude, lon: pos.longitude);
  }
}
