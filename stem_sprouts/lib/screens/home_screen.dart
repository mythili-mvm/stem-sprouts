import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:confetti/confetti.dart';
import '../services/hive_services.dart';
import 'calendar_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map? activity;
  final notesController = TextEditingController();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    loadToday();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void loadToday() {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var box = HiveService.getBox();
    activity = box.get(today);

    if (activity != null) {
      notesController.text = activity!['notes'] ?? '';
    }
    setState(() {});
  }

  void saveData() {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var box = HiveService.getBox();

    var existing = box.get(today);

    existing['notes'] = notesController.text;
    existing['isCompleted'] = true;

    box.put(today, existing);

    _confettiController.play(); // 🎉 Play confetti

    loadToday();
  }

  int getCompletedCount() {
    var box = HiveService.getBox();
    int count = 0;

    for (var key in box.keys) {
      var item = box.get(key);
      if (item != null && item['isCompleted'] == true) {
        count++;
      }
    }

    return count;
  }

  Widget _infoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (activity == null) {
      return const Scaffold(
        body: Center(child: Text("No activity for today")),
      );
    }

    int completed = getCompletedCount();
    double progress = completed / 90;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text(
          "🌱 STEM Sprouts",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CalendarScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                // 🌟 Progress Card
                Card(
                  color: Colors.orange.shade100,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "🌟 STEM Progress",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text("$completed / 90 Days Completed"),
                        const SizedBox(height: 10),

                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: progress),
                          duration:
                          const Duration(milliseconds: 800),
                          builder: (context, value, child) {
                            return ClipRRect(
                              borderRadius:
                              BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: value,
                                minHeight: 12,
                                backgroundColor:
                                Colors.white,
                                color: Colors.orange,
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 8),

                        TweenAnimationBuilder<double>(
                          tween: Tween(
                              begin: 0,
                              end: progress * 100),
                          duration:
                          const Duration(milliseconds: 800),
                          builder: (context, value, child) {
                            return Text(
                              "${value.toInt()}% Completed",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 🎯 Activity Card
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Day ${activity!['dayNumber']}",
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          activity!['title'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _infoTile("🔬 Science",
                            activity!['scienceActivity']),
                        _infoTile(
                            "🛠 Tool", activity!['techTool']),
                        _infoTile(
                            "🏗 Challenge",
                            activity![
                            'engineeringChallenge']),
                        _infoTile(
                            "🔢 Math", activity!['mathFocus']),
                        _infoTile("⏱ Duration",
                            activity!['duration']),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 📝 Notes
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: "Parent Notes",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),

                const SizedBox(height: 20),

                // 🚀 Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: activity!['isCompleted']
                      ? null
                      : saveData,
                  child: Text(
                    activity!['isCompleted']
                        ? "🎉 Completed!"
                        : "🚀 Mark as Done",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // 🎉 Confetti Layer
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality:
            BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.blue,
              Colors.green,
              Colors.orange,
              Colors.purple,
              Colors.pink,
            ],
          ),
        ],
      ),
    );
  }
}