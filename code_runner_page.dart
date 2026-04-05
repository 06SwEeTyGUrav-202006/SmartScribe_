
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/code_history.dart';
import '../services/code_history_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CodeRunnerPage extends StatefulWidget {
  const CodeRunnerPage({super.key});

  @override
  State<CodeRunnerPage> createState() => _CodeRunnerPageState();
}

class _CodeRunnerPageState extends State<CodeRunnerPage> {
  // --- PALETTE COLORS ---
  final Color colorBgDark = Color(0xFF1A3263);      // Deep Navy
  final Color colorSecondary = Color(0xFF547792);  // Steel Blue
  final Color colorAccent = Color(0xFFFAB95B);     // Gold/Orange
  final Color colorLight = Color(0xFFE8E2DB);      // Beige/White
  final Color colorWhite = Color(0xFFFFFFFF);      // Pure White

  final TextEditingController codeController = TextEditingController();
  final TextEditingController inputController = TextEditingController();

  String selectedLanguage = "python";
  String output = "";
  bool isLoading = false;



  Future<void> runCode() async {
    setState(() => isLoading = true);

    try {
      final url = Uri.parse("");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "language": selectedLanguage,
          "code": codeController.text,
          "input": inputController.text,
        }),
      );

      final data = jsonDecode(response.body);
      final result = data["output"] ?? data["error"] ?? "No output";

      setState(() {
        output = result;
      });

      // --- Prompt user for a custom title ---
      String? title = await showDialog<String>(
        context: context,
        builder: (context) {
          final titleController = TextEditingController();
          return AlertDialog(
            title: const Text("Name Your Code"),
            content: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Enter a title for this code snippet",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null), // Cancel
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, titleController.text.trim()),
                child: const Text("Save"),
              ),
            ],
          );
        },
      );

      // If user cancels or leaves it blank, fallback to first line
      if (title == null || title.isEmpty) {
        title = codeController.text.split("\n").first;
        if (title.length > 30) title = title.substring(0, 30);
      }

      // --- Save to SharedPreferences ---
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList("code_history") ?? [];

      final item = {
        "title": title,
        "language": selectedLanguage,
        "code": codeController.text,
        "output": result,
        "time": DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now()),
      };

      history.add(jsonEncode(item));
      await prefs.setStringList("code_history", history);

      // --- Save to CodeHistoryService (if using) ---
      await CodeHistoryService.saveHistory(
        CodeHistory(
          language: selectedLanguage,
          code: codeController.text,
          input: inputController.text,
          output: result,
          time: DateTime.now().toString(),
        ),
      );
    } catch (e) {
      setState(() => output = "❌ Error: $e");
    }

    setState(() => isLoading = false);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: colorWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: colorBgDark),
        title:  Text(
          "Code Runner",
          style: TextStyle(
            color: colorBgDark,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: colorLight,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon:  Icon(Icons.history, color: colorBgDark),
              onPressed: () {
                Navigator.pushNamed(context, "/history");
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- LANGUAGE SELECTOR ---
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   decoration: BoxDecoration(
            //     color: colorLight,
            //     borderRadius: BorderRadius.circular(12),
            //     border: Border.all(color: colorBgDark.withOpacity(0.1)),
            //   ),
            //   child: DropdownButtonHideUnderline(
            //     child: DropdownButton<String>(
            //       value: selectedLanguage,
            //       iconEnabledColor: colorBgDark,
            //       iconSize: 28,
            //       style:  TextStyle(
            //         color: colorBgDark,
            //         fontSize: 16,
            //         fontWeight: FontWeight.bold,
            //       ),
            //       dropdownColor: colorWhite,
            //       items: const [
            //         DropdownMenuItem(value: "python", child: Text("🐍 Python")),
            //         DropdownMenuItem(value: "javascript", child: Text("⚡ JavaScript")),
            //         DropdownMenuItem(value: "java", child: Text("☕ Java")),
            //       ],
            //       onChanged: (v) => setState(() => selectedLanguage = v!),
            //     ),
            //   ),
            // ),

            const SizedBox(height: 16),

            // --- CODE EDITOR (IDE Style) ---
            Container(
              decoration: BoxDecoration(
                color: colorBgDark,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorBgDark.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: codeController,
                maxLines: 12,
                style:  TextStyle(
                  color: colorLight,
                  fontFamily: 'monospace', // Monospace for code
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: "// Write your $selectedLanguage code here...",
                  hintStyle: TextStyle(
                    color: colorLight.withOpacity(0.4),
                    fontFamily: 'monospace',
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // --- INPUT FIELD ---
            TextField(
              controller: inputController,
              maxLines: 2,
              style: TextStyle(color: colorBgDark, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: "Input (for input() / Scanner)...",
                filled: true,
                fillColor: colorWhite,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorBgDark, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorAccent, width: 2),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 16),

            // --- RUN BUTTON ---
            SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : runCode,
                icon: isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Color(0xFF1A3263), strokeWidth: 2))
                    : const Icon(Icons.play_arrow, color: Color(0xFF1A3263)),
                label: Text(
                  isLoading ? "Running..." : "Run Code",
                  style: const TextStyle(
                    color: Color(0xFF1A3263),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorAccent,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // --- OUTPUT TERMINAL ---
            Container(
              constraints: const BoxConstraints(minHeight: 150),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF), // Very Dark Grey/Black for terminal look
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorBgDark),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.yellowAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.greenAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "TERMINAL OUTPUT",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      output.isEmpty ? "Output will appear here..." : output,
                      style: TextStyle(
                        color: output.contains("Error") ? Colors.redAccent : colorLight,
                        fontFamily: 'monospace',
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}