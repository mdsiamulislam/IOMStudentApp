import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class QnaPage extends StatefulWidget {
  const QnaPage({Key? key}) : super(key: key);

  @override
  _QnaPageState createState() => _QnaPageState();
}

class _QnaPageState extends State<QnaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Q&A',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Questions & Answers',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildQnaItem(
                    question:
                        'Is IOM affiliated with any specific group or faction?',
                    answer:
                        'No, IOM is a completely non-political institution...',
                  ),
                  _buildQnaItem(
                    question:
                        'Does IOM\'s Alim Preparatory Course follow the exact syllabus of Qawmi Madrasas?',
                    answer:
                        'No, the Alim Preparatory Course at IOM does not follow...',
                  ),
                  _buildQnaItem(
                    question: 'Is it necessary to wear a niqab for classes?',
                    answer:
                        'No, wearing a niqab is not necessary for classes...',
                  ),
                  _buildQnaItem(
                    question:
                        'What is the primary method of studying Islamic knowledge?',
                    answer:
                        'The primary and most effective method is attending offline...',
                  ),
                  _buildQnaItem(
                    question:
                        'How do IOU and IOM compare in terms of:\n- Medium of Instruction\n- Cost\n- Live Classes\n- Timing\n- Examination Method',
                    answer:
                        '- **Medium of Instruction:** If you are proficient in English...',
                  ),
                  _buildQnaItem(
                    question:
                        'Where can I contact IOU and IOM for more information?',
                    answer:
                        '- **IOU:** [www.iou.edu.gm](http://www.iou.edu.gm)\n- **IOM:** [www.iom.edu.bd](http://www.iom.edu.bd) and [Facebook](https://www.facebook.com/iom.edu.bd/)',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQnaItem({required String question, required String answer}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.green[50],
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        leading: Icon(Icons.question_answer, color: Colors.green),
        title: Text(
          question,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  answer,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                if (answer.contains('http')) ...[
                  // Extract URLs from the answer text and create clickable links
                  ..._extractUrls(answer).map((url) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => _launchURL(url),
                          child: Text(
                            url,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const Divider(color: Colors.green, thickness: 1),
                      ],
                    );
                  }).toList(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> _extractUrls(String text) {
    final RegExp urlPattern = RegExp(
      r'(http[s]?://[^\s]+)',
      caseSensitive: false,
      multiLine: false,
    );
    return urlPattern.allMatches(text).map((match) => match.group(0)!).toList();
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
