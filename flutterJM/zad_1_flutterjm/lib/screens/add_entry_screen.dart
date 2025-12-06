import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
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
  File? imageFile;

  Future<void> takePicture() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    final controller = CameraController(camera, ResolutionPreset.medium);
    await controller.initialize();

    final image = await controller.takePicture();
    setState(() => imageFile = File(image.path));

    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final api = ApiService();

    return Scaffold(
      appBar: AppBar(title: const Text("Dodaj wpis")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Tytuł")),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: "Opis")),
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

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final entry = JournalEntry(
                  id: "",
                  title: titleCtrl.text,
                  description: descCtrl.text,
                  imagePath: null, 
                  date: DateTime.now().toString(),
                );

                await api.addEntry(entry);
                Navigator.pop(context);
              },
              child: const Text("Zapisz"),
            )
          ],
        ),
      ),
    );
  }
}
