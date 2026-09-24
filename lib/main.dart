import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/globe_provider.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CosmicOrbitApp());
}

class CosmicOrbitApp extends StatelessWidget {
  const CosmicOrbitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GlobeProvider(),
      child: Builder(
        builder: (context) {
          final isIOS = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

          if (isIOS) {
            return CupertinoApp(
              title: 'GeoOrbit Pro',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.cupertinoDarkTheme,
              home: const HomeScreen(),
            );
          }
          return MaterialApp(
            title: 'GeoOrbit Pro',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.materialDarkTheme,
            darkTheme: AppTheme.materialDarkTheme,
            themeMode: ThemeMode.dark,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
