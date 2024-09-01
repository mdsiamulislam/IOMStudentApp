import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PreviousClassRecordsPage extends StatelessWidget {
  const PreviousClassRecordsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Class Records'),
        elevation: 4,
        backgroundColor: Colors.green[800], // Custom color
        foregroundColor: Colors.white, // Custom text color
      ),
      body: FutureBuilder<List<SubjectRecord>>(
        future: fetchClassRecords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available.'));
          } else {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: snapshot.data!
                  .map((subject) => _buildSubjectSection(
                        context,
                        subjectName: subject.name,
                        classRecords: subject.records,
                      ))
                  .toList(),
            );
          }
        },
      ),
    );
  }

  Future<List<SubjectRecord>> fetchClassRecords() async {
    final response =
        await http.get(Uri.parse('https://json.link/FXAFL2wFb1.json'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => SubjectRecord.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load class records');
    }
  }

  Widget _buildSubjectSection(
    BuildContext context, {
    required String subjectName,
    required List<ClassRecord> classRecords,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      color: Colors.green[50], // Custom background color
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subjectName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[800], // Custom text color
              ),
            ),
            const SizedBox(height: 12),
            ...classRecords
                .map((record) => _buildClassRecordTile(context, record))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildClassRecordTile(BuildContext context, ClassRecord record) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.play_circle_fill, color: Colors.green[800]),
          title: Text(
            record.title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          onTap: () => _launchURL(record.url),
        ),
        Divider(color: Colors.green[200]), // Custom divider color
      ],
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

class SubjectRecord {
  final String name;
  final List<ClassRecord> records;

  SubjectRecord({
    required this.name,
    required this.records,
  });

  factory SubjectRecord.fromJson(Map<String, dynamic> json) {
    return SubjectRecord(
      name: json['subject'] ?? 'Unknown Subject',
      records: (json['records'] as List<dynamic>)
          .map((record) => ClassRecord.fromJson(record))
          .toList(),
    );
  }
}

class ClassRecord {
  final String title;
  final String url;

  ClassRecord({
    required this.title,
    required this.url,
  });

  factory ClassRecord.fromJson(Map<String, dynamic> json) {
    return ClassRecord(
      title: json['title'] ?? 'Unknown Class',
      url: json['url'] ?? '',
    );
  }
}
