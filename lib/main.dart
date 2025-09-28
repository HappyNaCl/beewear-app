import 'package:beewear_app/routing/router.dart';
import 'package:beewear_app/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BeeWear',
      theme: ThemeData(
        colorScheme: AppColors.lightColorScheme,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: AppColors.darkColorScheme,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      routerConfig: router(),
    );
  }
}
