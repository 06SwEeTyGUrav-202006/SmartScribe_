class CodeHistory {
  final String language;
  final String code;
  final String input;
  final String output;
  final String time;

  CodeHistory({
    required this.language,
    required this.code,
    required this.input,
    required this.output,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
    "language": language,
    "code": code,
    "input": input,
    "output": output,
    "time": time,
  };

  factory CodeHistory.fromJson(Map<String, dynamic> json) {
    return CodeHistory(
      language: json["language"],
      code: json["code"],
      input: json["input"],
      output: json["output"],
      time: json["time"],
    );
  }
}
