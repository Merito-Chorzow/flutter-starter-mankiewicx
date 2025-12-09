import 'package:flutter/material.dart';
import 'dart:io';
import '../models/journal_entry.dart';

class EntryDetailsScreen extends StatefulWidget {
  final JournalEntry entry;
  const EntryDetailsScreen({super.key, required this.entry});
  @override
  State<EntryDetailsScreen> createState() => _EntryDetailsScreenState();
}

class _EntryDetailsScreenState extends State<EntryDetailsScreen> {
  bool _imageExists = false;
  @override
  void initState() {
    super.initState();
    if (widget.entry.imagePath != null) {
      File(widget.entry.imagePath!).exists().then((exists) {
        if (exists) {
          setState(() {
            _imageExists = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    return Scaffold(
      appBar: AppBar(title: Text(entry.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entry.imagePath != null && _imageExists)
              Image.file(
                File(entry.imagePath!),
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            else
              const Center(child: Icon(Icons.image_not_supported, size: 120)),
            const SizedBox(height: 20),
            const Text("Opis:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(entry.description),
            const SizedBox(height: 20),
            const Text(
              "Lokalizacja:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(entry.date ?? "Brak danych GPS"),
          ],
        ),
      ),
    );
  }
}
