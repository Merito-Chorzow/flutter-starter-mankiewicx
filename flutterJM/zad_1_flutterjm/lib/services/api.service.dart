import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/journal_entry.dart';

class ApiService {
  static const String baseUrl = "https://.com/entries";

  Future<List<JournalEntry>> fetchEntries() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => JournalEntry.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load entries");
    }
  }

  Future<void> addEntry(JournalEntry entry) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(entry.toJson()),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception("Failed to create entry");
    }
  }
}
