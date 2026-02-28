class Activity {
  String date;
  int dayNumber;
  String theme;
  String title;
  String scienceActivity;
  String techTool;
  String engineeringChallenge;
  String mathFocus;
  String duration;
  String notes;
  bool isCompleted;

  Activity({
    required this.date,
    required this.dayNumber,
    required this.theme,
    required this.title,
    required this.scienceActivity,
    required this.techTool,
    required this.engineeringChallenge,
    required this.mathFocus,
    required this.duration,
    required this.notes,
    required this.isCompleted,
  });

  factory Activity.fromJson(Map json) {
    return Activity(
      date: json['date'],
      dayNumber: json['dayNumber'],
      theme: json['theme'],
      title: json['title'],
      scienceActivity: json['scienceActivity'],
      techTool: json['techTool'],
      engineeringChallenge: json['engineeringChallenge'],
      mathFocus: json['mathFocus'],
      duration: json['duration'],
      notes: json['notes'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'dayNumber': dayNumber,
      'theme': theme,
      'title': title,
      'scienceActivity': scienceActivity,
      'techTool': techTool,
      'engineeringChallenge': engineeringChallenge,
      'mathFocus': mathFocus,
      'duration': duration,
      'notes': notes,
      'isCompleted': isCompleted,
    };
  }
}