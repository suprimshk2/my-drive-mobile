import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mydrivenepal/di/config/config_model.dart';

class ConfigProvider {
  Future<AppConfig> loadConfig() async {
    final configPath = dotenv.env["CONFIG_PATH"]!;

    final String jsonString = await rootBundle.loadString(configPath);
    final jsonMap = json.decode(jsonString);
    return AppConfig.fromJson(jsonMap);
  }
}
