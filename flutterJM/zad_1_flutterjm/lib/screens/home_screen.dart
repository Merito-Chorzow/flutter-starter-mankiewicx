import 'package:flutter/material.dart';
import '../services/api.service.dart';
import '../models/journal_entry.dart';
import 'add_entry_screen.dart';
import 'entry_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService api = ApiService();
  late Future<List<JournalEntry>> entriesFuture;

  @override
  void initState() {
    super.initState();
    entriesFuture = api.fetchEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Geo Journal")),
      body: FutureBuilder<List<JournalEntry>>(
        future: entriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Błąd: ${snapshot.error}"));
          }
          final entries = snapshot.data ?? [];
          if (entries.isEmpty) {
            return const Center(child: Text("Brak wpisów"));
          }

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return ListTile(
                leading: entry.imagePath != null
                    ? Image.network(entry.imagePath!, width: 50)
                    : const Icon(Icons.image_not_supported),
                title: Text(entry.title),
                subtitle: Text(entry.date ?? ""),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EntryDetailsScreen(entry: entry),
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEntryScreen()),
          );
          setState(() {
            entriesFuture = api.fetchEntries();
          });
        },
      ),
    );
  }
}
