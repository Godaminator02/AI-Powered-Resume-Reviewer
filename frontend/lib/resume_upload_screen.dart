import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'api_services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ResumeUploadScreen extends StatefulWidget {
  @override
  _ResumeUploadScreenState createState() => _ResumeUploadScreenState();
}

class _ResumeUploadScreenState extends State<ResumeUploadScreen> {
  File? _resume;
  bool _isUploading = false;
  Map<String, dynamic>? _feedbackData;

  Future<void> _pickResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _resume = File(result.files.single.path!);
        _feedbackData = null; // Reset feedback for new uploads
      });
    }
  }

  Future<void> _uploadResume() async {
    if (_resume == null) return;

    setState(() => _isUploading = true);

    var response = await ResumeAPI.uploadResume(_resume!);
    setState(() {
      _isUploading = false;
      if (response != null) {
        _feedbackData = response;
      } else {
        _feedbackData = {
          "error": "Failed to analyze resume. Please try again."
        };
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Black background
      appBar: AppBar(
        title: Text(
          "ATSPro",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.orangeAccent, // Light orange text
          ),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.grey[900], // Dark gray app bar
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon Section
            Icon(
              Icons.upload_file,
              size: 100,
              color: Colors.orangeAccent, // Light orange icon
            ),
            SizedBox(height: 20),

            // Main Heading
            Text(
              "Upload Your Resume (PDF)",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
            SizedBox(height: 10),

            // Description
            Text(
              "Our AI will analyze your resume and provide personalized feedback to boost your chances of getting hired.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            ),
            SizedBox(height: 30),

            // File Selection Button
            ElevatedButton.icon(
              onPressed: _pickResume,
              icon: Icon(
                Icons.file_present_rounded,
                size: 24,
                color: Colors.black,
              ),
              label: Text(
                "Select Resume",
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                foregroundColor: Colors.black, // Light orange button
                backgroundColor: Colors.orangeAccent, // Text color when pressed
                shadowColor: Colors.orange.withOpacity(0.9),
                elevation: 6,
              ),
            ),
            SizedBox(height: 20),

            // File Display Section
            _resume != null
                ? Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[850], // Dark gray container
                      border: Border.all(color: Colors.orangeAccent, width: 1),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 10,
                            offset: Offset(0, 4)),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.picture_as_pdf, color: Colors.orangeAccent),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _resume!.path.split('/').last,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.orangeAccent,
                            ),
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.cancel_outlined,
                                color: Colors.redAccent.withOpacity(0.9)),
                            onPressed: () {
                              setState(() {
                                _resume = null;
                                _feedbackData = null;
                              });
                            }),
                      ],
                    ),
                  )
                : Text(
                    "No resume selected yet.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
            SizedBox(height: 25),

            // Upload Button
            ElevatedButton(
              onPressed: _resume != null ? _uploadResume : null,
              child: _isUploading
                  ? CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2,
                    )
                  : Text("Upload & Analyze"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                foregroundColor:
                    _resume != null ? Colors.black : Colors.grey[800],
                backgroundColor: Colors.orangeAccent, // Text color for button
                shadowColor: Colors.orange.withOpacity(0.9),
                elevation: 6,
              ),
            ),
            SizedBox(height: 40),

            // Feedback Section
            if (_feedbackData != null)
              _buildFeedbackUI(_feedbackData!)
            else
              Text(
                "Feedback will appear here after analysis.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[500],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackUI(Map<String, dynamic> feedbackData) {
    if (feedbackData.containsKey("error")) {
      return Text(feedbackData["error"],
          style: TextStyle(color: Colors.redAccent, fontSize: 16));
    }

    String markdownText = feedbackData["ai_feedback"] != null
        ? feedbackData["ai_feedback"].replaceAll("Resume Score", "ATS Score")
        : "No feedback available.";

    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orangeAccent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("📢 AI Resume Feedback",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent)),
          SizedBox(height: 10),
          MarkdownBody(
            data: markdownText, // Now it correctly renders the Markdown
            styleSheet: MarkdownStyleSheet(
              h2: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent),
              p: TextStyle(fontSize: 14, color: Colors.black87),
              listBullet: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
