import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/globe_provider.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GlobeProvider(),
      child:const MaterialApp(
        title: 'Cosmic Globe',
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
