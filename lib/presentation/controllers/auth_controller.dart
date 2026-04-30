import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/models.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<UserSessionModel?>>((ref) => AuthController());

class AuthController extends StateNotifier<AsyncValue<UserSessionModel?>> {
  AuthController() : super(const AsyncData(null));
  Future<void> login(String email, String pass) async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(milliseconds: 600));
    if (pass.length < 6) { state = AsyncError('Clave inválida', StackTrace.current); return; }
    state = AsyncData(UserSessionModel(email: email, name: email.split('@').first, loggedIn: true));
  }
  Future<void> logout() async => state = const AsyncData(null);
}
