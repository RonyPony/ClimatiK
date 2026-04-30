import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget { const SplashScreen({super.key}); @override State<SplashScreen> createState() => _SplashScreenState(); }
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() { super.initState(); Future.delayed(const Duration(seconds: 2), () { if (mounted) context.go('/home'); }); }
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0EA5E9), Color(0xFF1E1B4B)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: Center(child: const Text('Climatik', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)).animate().fadeIn(duration: 700.ms).scale()),
    ),
  );
}
