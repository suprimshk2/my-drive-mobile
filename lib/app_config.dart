import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static Future<void> load() async {
    String flavor = const String.fromEnvironment('FLAVOR');

    if (flavor.isNotEmpty) {
      flavor = '.env.$flavor';
    } else {
      flavor = '.env';
    }

    await dotenv.load(
      fileName: flavor,
    );
  }
}
