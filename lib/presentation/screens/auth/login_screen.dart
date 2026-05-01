import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            TextField(
                controller: email,
                decoration: const InputDecoration(labelText: 'Email')),
            TextField(
                controller: pass,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: state.isLoading
                    ? null
                    : () => ref
                        .read(authControllerProvider.notifier)
                        .login(email.text, pass.text),
                child: const Text('Entrar')),
            TextButton(
                onPressed: () => context.push('/register'),
                child: const Text('Crear cuenta')),
            if (state.hasError) Text(state.error.toString())
          ])),
      floatingActionButton: state.value != null
          ? FloatingActionButton(
              onPressed: () =>
                  ref.read(authControllerProvider.notifier).logout(),
              child: const Icon(Icons.logout))
          : null,
    );
  }
}
