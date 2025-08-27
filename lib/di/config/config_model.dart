import 'dart:ui';

class AppConfig {
  final String appName;
  final TextFieldConfig textField;
  final ThemeConfig themeConfig;

  AppConfig({
    required this.appName,
    required this.textField,
    required this.themeConfig,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      appName: json['app_name'],
      textField: TextFieldConfig.fromJson(json['text_field']),
      themeConfig: ThemeConfig.fromJson(json['theme_config']),
    );
  }
}

class ThemeConfig {
  final ThemeModeConfig light;
  final ThemeModeConfig dark;

  ThemeConfig({
    required this.light,
    required this.dark,
  });

  factory ThemeConfig.fromJson(Map<String, dynamic> json) {
    return ThemeConfig(
      light: ThemeModeConfig.fromJson(json['light']),
      dark: ThemeModeConfig.fromJson(json['dark']),
    );
  }
}

class TextFieldConfig {
  final String usernameLabel;
  final String usernameHintText;

  TextFieldConfig({
    required this.usernameLabel,
    required this.usernameHintText,
  });

  factory TextFieldConfig.fromJson(Map<String, dynamic> json) {
    return TextFieldConfig(
      usernameLabel: json['username_label'],
      usernameHintText: json['username_hint_txt'],
    );
  }
}

class ColorPalette {
  final Color strong;
  final Color bold;
  final Color main;
  final Color soft;
  final Color subtle;

  ColorPalette({
    required this.strong,
    required this.bold,
    required this.main,
    required this.soft,
    required this.subtle,
  });

  factory ColorPalette.fromJson(Map<String, dynamic> json) {
    return ColorPalette(
      strong: Color(int.parse(json['strong'])),
      bold: Color(int.parse(json['bold'])),
      main: Color(int.parse(json['main'])),
      soft: Color(int.parse(json['soft'])),
      subtle: Color(int.parse(json['subtle'])),
    );
  }
}

class GradientColors {
  final List<Color> button;

  GradientColors({
    required this.button,
  });

  factory GradientColors.fromJson(Map<String, dynamic> json) {
    return GradientColors(
      button: (json['button'] as List)
          .map((color) => Color(int.parse(color)))
          .toList(),
    );
  }
}

class ThemeModeConfig {
  final ColorPalette primary;
  final ColorPalette secondary;
  final ColorPalette success;
  final ColorPalette warning;
  final ColorPalette error;
  final ColorPalette info;
  final ColorPalette gray;
  final GradientColors gradients;

  ThemeModeConfig({
    required this.primary,
    required this.secondary,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.gray,
    required this.gradients,
  });

  factory ThemeModeConfig.fromJson(Map<String, dynamic> json) {
    return ThemeModeConfig(
      primary: ColorPalette.fromJson(json['primary']),
      secondary: ColorPalette.fromJson(json['secondary']),
      success: ColorPalette.fromJson(json['success']),
      warning: ColorPalette.fromJson(json['warning']),
      error: ColorPalette.fromJson(json['error']),
      info: ColorPalette.fromJson(json['info']),
      gray: ColorPalette.fromJson(json['gray']),
      gradients: GradientColors.fromJson(json['gradients']),
    );
  }
}
