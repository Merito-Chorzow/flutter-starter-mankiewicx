class JournalEntry {
  final String id;
  final String title;
  final String description;
  final String? imagePath;
  final String? date;

  JournalEntry({
    required this.id,
    required this.title,
    required this.description,
    this.imagePath,
    this.date,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'].toString(),
      title: json['title'],
      description: json['description'],
      imagePath: json['imagePath'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "imagePath": imagePath,
        "date": date,
      };
}
