import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'services/transcription_service.dart';
import 'services/summary_service.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool _isProcessing = false;
  String? _fileName;

  Future<void> _pickAudio() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result == null || result.files.single.path == null) {
      return;
    }

    final filePath = result.files.single.path!;
    _fileName = result.files.single.name;

    setState(() => _isProcessing = true);

    /// 🎧 STEP 1: TRANSCRIBE AUDIO
    final transcription =
    await TranscriptionService.transcribeAudio(filePath);

    if (transcription == null || transcription.trim().isEmpty) {
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Transcription failed")),
      );
      return;
    }

    /// 🧠 STEP 2: SUMMARIZE (Hindi → English)
    final summary =
    await SummarizeService.summarizeText(transcription);

    setState(() => _isProcessing = false);

    /// 📄 STEP 3: SHOW RESULT
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("✨ AI Summary"),
        content: SingleChildScrollView(
          child: Text(summary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Audio"),
        centerTitle: true,
      ),
      body: Center(
        child: _isProcessing
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text("Processing audio..."),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.upload_file,
                size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickAudio,
              child: const Text("Pick Audio File"),
            ),
            if (_fileName != null) ...[
              const SizedBox(height: 12),
              Text("Selected: $_fileName"),
            ]
          ],
        ),
      ),
    );
  }
}
