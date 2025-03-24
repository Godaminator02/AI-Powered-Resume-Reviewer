import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ResumeAPI {
  final url = "http://10.0.2.2:8000/upload_resume/";

  static Future<Map<String, dynamic>?> uploadResume(File resumeFile) async {
    print('Uploading resume: ${resumeFile.path}');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://10.0.2.2:8000/upload_resume/"),
    );
    request.files
        .add(await http.MultipartFile.fromPath('file', resumeFile.path));

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print('Response Status: ${response.statusCode}');
      print('Response Body: $responseBody'); // Debug print

      if (response.statusCode == 200) {
        return jsonDecode(responseBody);
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e'); // Debugging
      return null;
    }
  }
}
