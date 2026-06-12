import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/providers.dart';
import '../../controllers/settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: RadioGroup<ThemeMode>(
        groupValue: s.themeMode,
        onChanged: (v) {
          if (v != null) {
            ref.read(settingsControllerProvider.notifier).setTheme(v);
          }
        },
        child: ListView(
          children: [
            const ListTile(
              title: Text('Tema sistema'),
              trailing: Radio<ThemeMode>(value: ThemeMode.system),
            ),
            const ListTile(
              title: Text('Tema claro'),
              trailing: Radio<ThemeMode>(value: ThemeMode.light),
            ),
            const ListTile(
              title: Text('Tema oscuro'),
              trailing: Radio<ThemeMode>(value: ThemeMode.dark),
            ),
            SwitchListTile(
              value: s.animations,
              onChanged: (v) => ref
                  .read(settingsControllerProvider.notifier)
                  .toggleAnimations(v),
              title: const Text('Animaciones'),
            ),
            ListTile(
              title: const Text('Borrar ciudades guardadas'),
              onTap: () => ref.read(savedCitiesProvider.notifier).clear(),
            ),
          ],
        ),
      ),
    );
  }
}
