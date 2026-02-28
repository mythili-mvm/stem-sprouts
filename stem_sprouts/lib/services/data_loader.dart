import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../models/activity_model.dart';
import 'hive_services.dart';

class DataLoader {
  static Future<void> loadDataIfNeeded() async {
    var box = HiveService.getBox();

    if (box.isNotEmpty) return;

    String jsonString =
        await rootBundle.loadString('assets/stem_90_days.json');

    List data = json.decode(jsonString);

    for (var item in data) {
      Activity activity = Activity.fromJson(item);
      box.put(activity.date, activity.toJson());
    }
  }
}