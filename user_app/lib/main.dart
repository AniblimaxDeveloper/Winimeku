import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(const WinimekuApp());
}

class WinimekuApp extends StatelessWidget {
  const WinimekuApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wibinime',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black, appBarTheme: const AppBarTheme(backgroundColor: Colors.black)),
      home: const HomeScreen(),
    );
  }
}
