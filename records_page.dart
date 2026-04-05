
// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'services/transcription_service.dart';
//
// class RecordModule extends StatefulWidget {
//   const RecordModule({super.key});
//
//   @override
//   State<RecordModule> createState() => _RecordModuleState();
// }
//
// class _RecordModuleState extends State<RecordModule> {
//   FlutterSoundRecorder? _recorder;
//   bool _isRecorderReady = false;
//   bool _isRecording = false;
//   bool _isTranscribing = false;
//
//   String? _filePath;
//
//   Timer? _timer;
//   int _secondsRecorded = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _initRecorder();
//   }
//
//   Future<void> _initRecorder() async {
//     _recorder = FlutterSoundRecorder();
//
//     final micStatus = await Permission.microphone.request();
//     if (!micStatus.isGranted) {
//       debugPrint("❌ Microphone permission denied");
//       return;
//     }
//
//     await _recorder!.openRecorder();
//     _isRecorderReady = true;
//     debugPrint("✅ Recorder initialized");
//   }
//
//   void _startTimer() {
//     _secondsRecorded = 0;
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         _secondsRecorded++;
//       });
//     });
//   }
//
//   void _stopTimer() {
//     _timer?.cancel();
//     _timer = null;
//   }
//
//   String _formatTime(int seconds) {
//     final minutes = seconds ~/ 60;
//     final remainingSeconds = seconds % 60;
//     return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
//   }
//
//   Future<void> _startRecording() async {
//     if (!_isRecorderReady || _recorder == null) return;
//
//     final dir = await getApplicationDocumentsDirectory();
//     _filePath = "${dir.path}/audio.aac";
//
//     await _recorder!.startRecorder(
//       toFile: _filePath,
//       codec: Codec.aacADTS,
//     );
//
//     _startTimer();
//
//     setState(() => _isRecording = true);
//     debugPrint("🎙 Recording started: $_filePath");
//   }
//
//   Future<void> _stopRecording() async {
//     if (!_isRecorderReady || _recorder == null) return;
//
//     await _recorder!.stopRecorder();
//     _stopTimer();
//
//     setState(() => _isRecording = false);
//     debugPrint("🛑 Recording stopped");
//
//     setState(() => _isTranscribing = true);
//
//     final text =
//     await TranscriptionService.transcribeAudio(_filePath!);
//
//     setState(() => _isTranscribing = false);
//
//     if (text != null && text.isNotEmpty) {
//       debugPrint("📝 TRANSCRIBED TEXT: $text");
//
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: const Text("Transcription"),
//           content: Text(text),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("OK"),
//             )
//           ],
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("❌ Transcription failed")),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     _recorder?.closeRecorder();
//     _recorder = null;
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           if (_isTranscribing) ...[
//             const CircularProgressIndicator(),
//             const SizedBox(height: 5),
//             const Text("Transcribing.."),
//           ] else ...[
//             Icon(
//               _isRecording ? Icons.mic : Icons.mic_none,
//               size: 80,
//               color: _isRecording ? Colors.red : Colors.grey,
//             ),
//             const SizedBox(height: 10),
//
//             if (_isRecording)
//               Text(
//                 _formatTime(_secondsRecorded),
//                 style: const TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.red,
//                 ),
//               ),
//
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _isRecording ? _stopRecording : _startRecording,
//               child: Text(
//                   _isRecording ? "Stop Recording" : "Start Recording"),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }



import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'services/transcription_service.dart';

class RecordModule extends StatefulWidget {
  const RecordModule({super.key});

  @override
  State<RecordModule> createState() => _RecordModuleState();
}

class _RecordModuleState extends State<RecordModule> {
  // --- PALETTE COLORS ---
  final Color colorBgDark = Color(0xFF1A3263);      // Deep Navy
  final Color colorSecondary = Color(0xFF547792);  // Steel Blue
  final Color colorAccent = Color(0xFFFAB95B);     // Gold/Orange
  final Color colorLight = Color(0xFFE8E2DB);      // Beige/White
  final Color colorWhite = Color(0xFFFFFFFF);      // Pure White

  // --- ORIGINAL LOGIC VARIABLES ---
  FlutterSoundRecorder? _recorder;
  bool _isRecorderReady = false;
  bool _isRecording = false;
  bool _isTranscribing = false;

  String? _filePath;

  Timer? _timer;
  int _secondsRecorded = 0;

  // --- ORIGINAL LOGIC METHODS (PRESERVED) ---
  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    _recorder = FlutterSoundRecorder();

    final micStatus = await Permission.microphone.request();
    if (!micStatus.isGranted) {
      debugPrint("❌ Microphone permission denied");
      return;
    }

    await _recorder!.openRecorder();
    _isRecorderReady = true;
    debugPrint("✅ Recorder initialized");
  }

  void _startTimer() {
    _secondsRecorded = 0;
    _timer = Timer.periodic(const Duration(seconds:1), (timer) {
      setState(() {
        _secondsRecorded++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  Future<void> _startRecording() async {
    if (!_isRecorderReady || _recorder == null) return;

    final dir = await getApplicationDocumentsDirectory();
    _filePath = "${dir.path}/audio.aac";

    await _recorder!.startRecorder(
      toFile: _filePath,
      codec: Codec.aacADTS,
    );

    _startTimer();

    setState(() => _isRecording = true);
    debugPrint("🎙 Recording started: $_filePath");
  }

  Future<void> _stopRecording() async {
    if (!_isRecorderReady || _recorder == null) return;

    await _recorder!.stopRecorder();
    _stopTimer();

    setState(() => _isRecording = false);
    debugPrint("🛑 Recording stopped");

    setState(() => _isTranscribing = true);

    final text =
    await TranscriptionService.transcribeAudio(_filePath!);

    setState(() => _isTranscribing = false);

    if (text != null && text.isNotEmpty) {
      debugPrint("📝 TRANSCRIBED TEXT: $text");

      // --- STYLED DIALOG ---
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: colorBgDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.transcribe, color: colorAccent, size: 28),
              SizedBox(width: 10),
              Text("Transcription", style: TextStyle(color: colorWhite, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(text, style: TextStyle(color: colorLight, height: 1.5, fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK", style: TextStyle(color: colorAccent, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("❌ Transcription failed"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder?.closeRecorder();
    _recorder = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite, // White Background
      appBar: AppBar(
        backgroundColor: colorWhite,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Record Audio",
          style: TextStyle(
            color: colorBgDark,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        iconTheme: IconThemeData(color: colorBgDark),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- TRANSCRIBING STATE ---
              if (_isTranscribing)
                Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: colorLight,
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: colorBgDark, strokeWidth: 6),
                      SizedBox(height: 20),
                      Text(
                        "Transcribing...",
                        style: TextStyle(color: colorBgDark, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              else ...[
                // --- RECORDING VISUALIZER ---
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isRecording ? colorBgDark.withOpacity(0.1) : colorLight,
                    border: Border.all(
                      color: _isRecording ? colorBgDark : Colors.transparent,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _isRecording ? colorBgDark.withOpacity(0.3) : colorBgDark.withOpacity(0.05),
                        blurRadius: 30,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    size: 80,
                    color: colorBgDark,
                  ),
                ),

                const SizedBox(height: 40),

                // --- TIMER DISPLAY ---
                Text(
                  _formatTime(_secondsRecorded),
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w300,
                    color: colorBgDark,
                    letterSpacing: 2,
                    fontFamily: 'monospace',
                  ),
                ),

                const SizedBox(height: 10),

                // --- STATUS TEXT ---
                Text(
                  _isRecording ? "Recording in progress" : "Tap button to start",
                  style: TextStyle(
                    fontSize: 16,
                    color: colorSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 60),

                // --- ACTION BUTTON ---
                SizedBox(
                  width: 220,
                  height: 65,
                  child: ElevatedButton(
                    onPressed: _isRecording ? _stopRecording : _startRecording,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isRecording ? Colors.red : colorBgDark,
                      elevation: _isRecording ? 0 : 4,
                      shadowColor: colorBgDark.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      _isRecording ? "Stop Recording" : "Start Recording",
                      style: TextStyle(
                        color: colorWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}