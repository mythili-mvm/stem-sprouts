import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const boxName = 'stemBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  static Box getBox() {
    return Hive.box(boxName);
  }
}