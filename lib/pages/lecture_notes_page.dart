import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class LectureNotesPage extends StatelessWidget {
  const LectureNotesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lecture Notes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green, // Main theme color
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Subject>>(
          future: fetchSubjects(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data available.'));
            } else {
              return ListView(
                children: snapshot.data!
                    .map((subject) => _buildSubjectSection(
                          context,
                          subject: subject.name,
                          notes: subject.notes,
                        ))
                    .toList(),
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<Subject>> fetchSubjects() async {
    final response =
        await http.get(Uri.parse('https://json.link/sXVRPpb81I.json'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Subject.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load subjects');
    }
  }

  Widget _buildSubjectSection(BuildContext context,
      {required String subject, required List<Note> notes}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.green[50],
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                subject,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...notes.map((note) => Column(
                  children: [
                    InkWell(
                      onTap: () => _launchURL(note.url),
                      child: Row(
                        children: [
                          Icon(Icons.note, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              note.name,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.green,
                      thickness: 1,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class Subject {
  final String name;
  final List<Note> notes;

  Subject({
    required this.name,
    required this.notes,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json['subject'] ?? 'Unknown Subject',
      notes: (json['notes'] as List<dynamic>)
          .map((note) => Note.fromJson(note))
          .toList(),
    );
  }
}

class Note {
  final String name;
  final String url;

  Note({
    required this.name,
    required this.url,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      name: json['name'] ?? 'Unknown Lecture',
      url: json['url'] ?? '',
    );
  }
}
