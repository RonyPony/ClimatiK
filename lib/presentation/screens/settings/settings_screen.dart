import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/providers.dart';
import '../../controllers/settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsControllerProvider);
    return Scaffold(appBar: AppBar(title: const Text('Configuración')), body: ListView(children: [
      ListTile(title: const Text('Tema sistema'), trailing: Radio<ThemeMode>(value: ThemeMode.system, groupValue: s.themeMode, onChanged: (v)=>ref.read(settingsControllerProvider.notifier).setTheme(v!))),
      ListTile(title: const Text('Tema claro'), trailing: Radio<ThemeMode>(value: ThemeMode.light, groupValue: s.themeMode, onChanged: (v)=>ref.read(settingsControllerProvider.notifier).setTheme(v!))),
      ListTile(title: const Text('Tema oscuro'), trailing: Radio<ThemeMode>(value: ThemeMode.dark, groupValue: s.themeMode, onChanged: (v)=>ref.read(settingsControllerProvider.notifier).setTheme(v!))),
      SwitchListTile(value: s.animations, onChanged: (v)=>ref.read(settingsControllerProvider.notifier).toggleAnimations(v), title: const Text('Animaciones')),
      ListTile(title: const Text('Borrar ciudades guardadas'), onTap: ()=>ref.read(savedCitiesProvider.notifier).clear()),
    ]));
  }
}
