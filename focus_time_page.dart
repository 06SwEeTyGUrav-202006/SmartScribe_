
// import 'dart:async';
// import 'package:flutter/material.dart';
// import '../services/firestore_service.dart';
//
// final FirestoreService _firestore = FirestoreService();
//
// class FocusPage extends StatefulWidget {
//   const FocusPage({super.key});
//
//   @override
//   State<FocusPage> createState() => _FocusPageState();
// }
//
// class _FocusPageState extends State<FocusPage> {
//   int focusMinutes = 25; // default 25 min
//   int focusSeconds = 0;  // default 0 sec
//   int totalSeconds = 25 * 60;
//
//   Timer? timer;
//   bool isRunning = false;
//
//   final TextEditingController _minutesController =
//   TextEditingController(text: "25");
//   final TextEditingController _secondsController =
//   TextEditingController(text: "00");
//
//   void startTimer() {
//     timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (totalSeconds == 0) {
//         timer.cancel();
//         _firestore.savePomodoroSession(focusMinutes);
//         setState(() => isRunning = false);
//
//         showDialog(
//           context: context,
//           builder: (_) => AlertDialog(
//             title: const Text("🎉 Focus Complete!"),
//             content: const Text("Great job! Take a short break."),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text("OK"),
//               )
//             ],
//           ),
//         );
//       } else {
//         setState(() => totalSeconds--);
//       }
//     });
//
//     setState(() => isRunning = true);
//   }
//
//   void pauseTimer() {
//     timer?.cancel();
//     setState(() => isRunning = false);
//   }
//
//   void resetTimer() {
//     timer?.cancel();
//     setState(() {
//       totalSeconds = (focusMinutes * 60) + focusSeconds;
//       isRunning = false;
//     });
//   }
//
//   void setCustomTime() {
//     final min = int.tryParse(_minutesController.text) ?? 0;
//     final sec = int.tryParse(_secondsController.text) ?? 0;
//
//     if (min < 0 || sec < 0 || sec > 59) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Enter valid minutes and seconds (0–59)")),
//       );
//       return;
//     }
//
//     setState(() {
//       focusMinutes = min;
//       focusSeconds = sec;
//       totalSeconds = (focusMinutes * 60) + focusSeconds;
//       isRunning = false;
//       timer?.cancel();
//     });
//   }
//
//   String get timeFormatted {
//     final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
//     final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
//     return "$minutes:$seconds";
//   }
//
//   @override
//   void dispose() {
//     timer?.cancel();
//     _minutesController.dispose();
//     _secondsController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Focus Time")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               children: [
//                 const SizedBox(height: 20),
//                 const Text(
//                   "Pomodoro Session",
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 30),
//                 Text(
//                   timeFormatted,
//                   style: const TextStyle(
//                     fontSize: 48,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       onPressed: isRunning ? pauseTimer : startTimer,
//                       child: Text(isRunning ? "Pause" : "Start"),
//                     ),
//                     const SizedBox(width: 16),
//                     ElevatedButton(
//                       onPressed: resetTimer,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                       ),
//                       child: const Text("Reset"),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//
//             // 🔽 Manual Time Setter at Bottom
//             Column(
//               children: [
//                 const Divider(),
//                 const SizedBox(height: 10),
//                 const Text(
//                   "Set Custom Focus Time",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _minutesController,
//                         keyboardType: TextInputType.number,
//                         decoration: const InputDecoration(
//                           labelText: "Minutes",
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: TextField(
//                         controller: _secondsController,
//                         keyboardType: TextInputType.number,
//                         decoration: const InputDecoration(
//                           labelText: "Seconds",
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: isRunning ? null : setCustomTime,
//                   child: const Text("Set Time"),
//                 ),
//                 const SizedBox(height: 10),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

final FirestoreService _firestore = FirestoreService();

class FocusPage extends StatefulWidget {
  const FocusPage({super.key});

  @override
  State<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends State<FocusPage> {
  // --- PALETTE COLORS ---
  final Color colorBgDark = Color(0xFF1A3263);      // Deep Navy
  final Color colorSecondary = Color(0xFF547792);  // Steel Blue
  final Color colorAccent = Color(0xFFFAB95B);     // Gold/Orange
  final Color colorLight = Color(0xFFE8E2DB);      // Beige/White
  final Color colorWhite = Color(0xFFFFFFFF);      // Pure White

  // --- LOGIC KEPT EXACTLY AS IS ---
  int focusMinutes = 25; // default 25 min
  int focusSeconds = 0;  // default 0 sec
  int totalSeconds = 25 * 60;

  Timer? timer;
  bool isRunning = false;

  final TextEditingController _minutesController =
  TextEditingController(text: "25");
  final TextEditingController _secondsController =
  TextEditingController(text: "00");

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (totalSeconds == 0) {
        timer.cancel();
        _firestore.savePomodoroSession(focusMinutes);
        setState(() => isRunning = false);

        // Styled Dialog
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Icon(Icons.check_circle, color: colorAccent, size: 32),
                SizedBox(width: 10),
                Text("Focus Complete!", style: TextStyle(color: colorBgDark, fontWeight: FontWeight.bold)),
              ],
            ),
            content: Text("Great job! Take a short break.", style: TextStyle(color: colorSecondary)),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorBgDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("OK", style: TextStyle(color: colorAccent)),
                ),
              )
            ],
          ),
        );
      } else {
        setState(() => totalSeconds--);
      }
    });

    setState(() => isRunning = true);
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() => isRunning = false);
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      totalSeconds = (focusMinutes * 60) + focusSeconds;
      isRunning = false;
    });
  }

  void setCustomTime() {
    final min = int.tryParse(_minutesController.text) ?? 0;
    final sec = int.tryParse(_secondsController.text) ?? 0;

    if (min < 0 || sec < 0 || sec > 59) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Enter valid minutes and seconds (0–59)"),
          backgroundColor: colorBgDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() {
      focusMinutes = min;
      focusSeconds = sec;
      totalSeconds = (focusMinutes * 60) + focusSeconds;
      isRunning = false;
      timer?.cancel();
    });
  }

  String get timeFormatted {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    timer?.cancel();
    _minutesController.dispose();
    _secondsController.dispose();
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
          "Focus Time",
          style: TextStyle(
            color: colorBgDark,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 40),

                // Timer Display
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorLight, // Beige container
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colorBgDark.withOpacity(0.05),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Text(
                    timeFormatted,
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w800,
                      color: colorBgDark, // Navy Text
                      letterSpacing: 2,
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // Main Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Start/Pause Button
                    SizedBox(
                      width: 140,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isRunning ? pauseTimer : startTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorAccent, // Gold Button
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          isRunning ? "Pause" : "Start",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorBgDark, // Navy Text
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),

                    // Reset Button
                    SizedBox(
                      width: 140,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: resetTimer,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colorSecondary, // Steel Blue Text
                          side: BorderSide(color: colorSecondary, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          "Reset",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Manual Time Setter Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorLight.withOpacity(0.4), // Very Light Beige
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Text(
                    "Set Custom Focus Time",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorBgDark,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // HEADER LABEL ABOVE THE BOX
                            Text(
                              "MINUTES",
                              style: TextStyle(
                                color: colorAccent, // Gold color for highlight
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 8), // Spacing between label and box

                            // INPUT BOX
                            TextField(
                              controller: _minutesController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 3,
                              style: TextStyle(
                                color: colorBgDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 32, // Large number
                                letterSpacing: 2,
                              ),
                              decoration: InputDecoration(
                                counterText: "", // Hides character count
                                filled: true,
                                fillColor: colorWhite,
                                // Navy Border
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: colorBgDark, width: 1.5),
                                ),
                                // Gold Border on Focus
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: colorAccent, width: 2),
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 20), // Height of the box
                              ),
                            ),
                          ],
                        ),
                      ),

                      // COLON SEPARATOR
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20), // Aligns visually with the input box
                        child: Text(
                          ":",
                          style: TextStyle(
                            color: colorBgDark,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // HEADER LABEL ABOVE THE BOX
                            Text(
                              "SECONDS",
                              style: TextStyle(
                                color: colorAccent, // Gold color for highlight
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // INPUT BOX
                            TextField(
                              controller: _secondsController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 2,
                              style: TextStyle(
                                color: colorBgDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                                letterSpacing: 2,
                              ),
                              decoration: InputDecoration(
                                counterText: "",
                                filled: true,
                                fillColor: colorWhite,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: colorBgDark, width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: colorAccent, width: 2),
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isRunning ? null : setCustomTime,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorBgDark, // Navy Button
                        disabledBackgroundColor: Colors.grey.shade300,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Set Time",
                        style: TextStyle(
                          color: colorAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}