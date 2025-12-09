import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import '../services/api.service.dart';
import '../models/journal_entry.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});
  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final ApiService api = ApiService();
  File? imageFile;
  String locationText = "Brak lokalizacji";
  Future<void> takePicture() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    final controller = CameraController(camera, ResolutionPreset.medium);
    await controller.initialize();
    final image = await controller.takePicture();
    setState(() => imageFile = File(image.path));
    await controller.dispose();
  }

  Future<void> getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => locationText = "Usługa GPS wyłączona.");
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => locationText = "Brak uprawnień do lokalizacji.");
        return;
      }
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );
      setState(() {
        locationText =
            "Lat: ${position.latitude.toStringAsFixed(4)}, Lon: ${position.longitude.toStringAsFixed(4)}";
      });
    } catch (e) {
      setState(() => locationText = "Błąd pobierania lokalizacji: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dodaj wpis")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: "Tytuł"),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: "Opis"),
            ),
            const SizedBox(height: 10),
            imageFile != null
                ? Image.file(imageFile!, height: 200)
                : const Text("Brak zdjęcia"),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: takePicture,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Zrób zdjęcie"),
            ),
            const SizedBox(height: 10),
            Text(locationText),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: getLocation,
              icon: const Icon(Icons.location_on),
              label: const Text("Pobierz lokalizację"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (titleCtrl.text.trim().isEmpty ||
                    descCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Tytuł i opis nie mogą być puste!"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                final entry = JournalEntry(
                  id: "",
                  title: titleCtrl.text,
                  description: descCtrl.text,
                  imagePath: imageFile?.path,
                  date: locationText,
                );
                try {
                  await api.addEntry(entry);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Wpis zapisany pomyślnie!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Błąd zapisu: ${e.toString()}"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("Zapisz"),
            ),
          ],
        ),
      ),
    );
  }
}
