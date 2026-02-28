import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../services/hive_services.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  Map<String, dynamic>? selectedActivity;

  void loadActivity(DateTime day) {
    String formatted = DateFormat('yyyy-MM-dd').format(day);
    var box = HiveService.getBox();
    selectedActivity = box.get(formatted);
    setState(() {});
  }

  bool isCompleted(DateTime day) {
    String formatted = DateFormat('yyyy-MM-dd').format(day);
    var box = HiveService.getBox();
    var activity = box.get(formatted);
    if (activity == null) return false;
    return activity['isCompleted'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("STEM Calendar")),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: focusedDay,
            firstDay: DateTime(2026, 3, 1),
            lastDay: DateTime(2026, 6, 30),
            selectedDayPredicate: (day) =>
                isSameDay(selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() {
                selectedDay = selected;
                focusedDay = focused;
              });
              loadActivity(selected);
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                if (isCompleted(day)) {
                  return Container(
                    margin: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }
                return null;
              },
            ),
          ),

          const SizedBox(height: 10),

          if (selectedActivity != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    Text(
                      "Day ${selectedActivity!['dayNumber']}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(selectedActivity!['title'],
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 8),
                    Text("Theme: ${selectedActivity!['theme']}"),
                    Text("Science: ${selectedActivity!['scienceActivity']}"),
                    Text("Tool: ${selectedActivity!['techTool']}"),
                    Text(
                        "Challenge: ${selectedActivity!['engineeringChallenge']}"),
                    Text("Math: ${selectedActivity!['mathFocus']}"),
                    Text("Notes: ${selectedActivity!['notes']}"),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}