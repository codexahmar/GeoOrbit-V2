import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/globe_provider.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SolarisApp());
}

class SolarisApp extends StatelessWidget {
  const SolarisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GlobeProvider(),
      child: Builder(
        builder: (context) {
          final isIOS = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

          if (isIOS) {
            return CupertinoApp(
              title: 'Solaris 3D',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.cupertinoDarkTheme,
              localizationsDelegates: const [
                DefaultMaterialLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
              ],
              home: const HomeScreen(),
            );
          }
          return MaterialApp(
            title: 'Solaris 3D',
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
