import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'lecture_notes_page.dart';
import 'moshq_page.dart';
import 'previous_class_records_page.dart';
import 'previous_semester_age.dart';
import 'q_n_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>> _dataFuture;
  bool _isLoading = false;

  late Timer _timer;
  late String _currentTime = '';
  late String _todayClassSchedule = '';

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchData();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    setState(() {
      DateTime now = DateTime.now();
      _currentTime =
          "${now.hour % 12 == 0 ? 12 : now.hour % 12}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";
    });
  }

  Future<Map<String, dynamic>> fetchData() async {
    final response =
        await http.get(Uri.parse('https://json.link/oJAzmxf0Pv.json'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _setTodayClassSchedule(data);
      return data; // Return entire JSON data
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _setTodayClassSchedule(Map<String, dynamic> data) {
    DateTime now = DateTime.now();
    String dayOfWeek = now.weekday.toString(); // Gets current day as a string
    var schedule = data['schedule'] as Map<String, dynamic>;

    setState(() {
      _todayClassSchedule =
          schedule[dayOfWeek]?.join('\n') ?? 'No classes today';
    });
  }

  Future<void> _launchURL(String url) async {
    setState(() {
      _isLoading = true;
    });

    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'IOM 2411',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green, // Changed to green theme
        elevation: 6,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else {
            final data = snapshot.data!;
            final classLink = data['classLink'];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Today's Class Card
                    SizedBox(
                      width: double.infinity,
                      //height: 250, // Removed fixed height for responsiveness
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.green[50],
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.school,
                                                color: Colors.green, size: 30),
                                            const SizedBox(width: 10),
                                            const Text(
                                              "Today's Class",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _todayClassSchedule,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        _currentTime,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(Icons.access_time,
                                          color: Colors.green, size: 30),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Divider(color: Colors.green[200]),
                              const SizedBox(height: 12),
                              const Text(
                                'The timetable of the Moshak classes can be found in the Moshak section',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Join Class and Moshq Buttons in a Row
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _launchURL(classLink);
                            },
                            icon:
                                const Icon(Icons.videocam, color: Colors.white),
                            label: const Text(
                              'Join the Class',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(double.infinity, 50),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MoshqPage()),
                              );
                            },
                            icon: const Icon(Icons.mic, color: Colors.white),
                            label: const Text(
                              'Moshq',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightGreen,
                              minimumSize: const Size(double.infinity, 50),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    Divider(color: Colors.green[300], thickness: 1),

                    const SizedBox(height: 24),

                    // Grid of Icon Buttons
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildIconButton(
                          context,
                          icon: Icons.video_library,
                          label: 'Previous Class Videos',
                          color: Colors.green,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PreviousClassRecordsPage()),
                            );
                          },
                        ),
                        _buildIconButton(
                          context,
                          icon: Icons.sticky_note_2,
                          label: 'Lecture Notes',
                          color: Colors.green,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LectureNotesPage()),
                            );
                          },
                        ),
                        _buildIconButton(
                          context,
                          icon: Icons.history_edu,
                          label: 'Previous Semester',
                          color: Colors.green,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PreviousSemesterPage()),
                            );
                          },
                        ),
                        _buildIconButton(
                          context,
                          icon: Icons.forum,
                          label: 'Q&A',
                          color: Colors.green,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QnaPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green[50],
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: () {
              _showAboutDevDialog(context);
            },
            child: const Text(
              "About Dev",
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
                decoration: TextDecoration.none, // Removed underline
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDevDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About Dev'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'App Developer:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('Md Siamul Islam Soaib'),
                const SizedBox(height: 8),
                const Text(
                  'GitHub:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _launchURL('https://github.com/mdsiamulislam/');
                  },
                  child: const Text(
                    'https://github.com/mdsiamulislam/',
                    style: TextStyle(
                      color: Colors.green,
                      decoration: TextDecoration.none, // Removed underline
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'API Developer:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('Mutaher Ahmed Shakil'),
                const SizedBox(height: 8),
                const Text(
                  'GitHub:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _launchURL('https://github.com/Mutah3r');
                  },
                  child: const Text(
                    'https://github.com/Mutah3r',
                    style: TextStyle(
                      color: Colors.green,
                      decoration: TextDecoration.none, // Removed underline
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close', style: TextStyle(color: Colors.green)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
