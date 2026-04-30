import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/cities/cities_screen.dart';
import '../../presentation/screens/city_detail/city_detail_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';

final routerProvider = Provider((ref) => GoRouter(routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/cities', builder: (_, __) => const CitiesScreen()),
      GoRoute(path: '/city/:name/:lat/:lon', builder: (_, s) => CityDetailScreen(name: s.pathParameters['name']!, lat: double.parse(s.pathParameters['lat']!), lon: double.parse(s.pathParameters['lon']!))),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
    ]));
