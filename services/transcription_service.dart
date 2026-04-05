import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class TranscriptionService {
  static Future<String?> transcribeAudio(String filePath) async {
    try {
      final file = File(filePath);

      if (!file.existsSync()) {
        print("❌ File not found");
        return null;
      }

      final uri = Uri.parse("http://10.40.9.50:5000/transcribe");
      final request = http.MultipartRequest("POST", uri);

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        print("❌ User not logged in");
        return null;
      }

      request.fields["uid"] = uid;

      request.files.add(
        http.MultipartFile(
          'audio',
          file.openRead(),
          await file.length(),
          filename: file.uri.pathSegments.last,
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonData = json.decode(responseBody);
        return jsonData['summary'];
      } else {
        print("❌ Server error: ${response.statusCode}");
        print(responseBody);
        return null;
      }
    } catch (e) {
      print("🔥 Transcription error: $e");
      return null;
    }
  }
}
