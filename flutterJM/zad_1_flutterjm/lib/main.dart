import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:camera/camera.dart';

late List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Błąd pobierania kamer: $e');
  }
  runApp(const GeoJournalApp());
}

class GeoJournalApp extends StatelessWidget {
  const GeoJournalApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo Journal',
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
