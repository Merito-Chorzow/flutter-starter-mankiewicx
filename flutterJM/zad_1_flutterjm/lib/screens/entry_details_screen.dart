import 'package:flutter/material.dart';
import '../models/journal_entry.dart';

class EntryDetailsScreen extends StatelessWidget {
  final JournalEntry entry;

  const EntryDetailsScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(entry.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            entry.imagePath != null
                ? Image.network(entry.imagePath!)
                : const Icon(Icons.image_not_supported, size: 120),
            const SizedBox(height: 10),
            Text(entry.description),
            const SizedBox(height: 10),
            Text("Data: ${entry.date}"),
          ],
        ),
      ),
    );
  }
}
