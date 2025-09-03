import 'dart:io';

import 'package:http_interceptor/http_interceptor.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:mydrivenepal/feature/home/data/model/app_version_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mydrivenepal/di/service_locator.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import '../../feature/theme/theme_provider.dart';

ThemeMode themeModeEnumFromString(String themeMode) {
  try {
    return ThemeMode.values.firstWhere(
        (e) => e.toString() == 'ThemeMode.${themeMode.toLowerCase()}');
  } catch (_) {
    return ThemeMode.system;
  }
}

Color getThemeColor(BuildContext context) {
  bool isLightTheme = locator<ThemeProvider>().isLightMode(context);
  return isLightTheme ? AppColors.black : AppColors.white;
}

bool isLightTheme(BuildContext context, {bool listen = true}) {
  return Provider.of<ThemeProvider>(context, listen: listen)
      .isLightMode(context);
}

String formatTime(int time) {
  final Duration duration = Duration(milliseconds: time * 1000);
  final DateFormat formatter = DateFormat('HH:mm:ss');
  final String formattedTime = formatter.format(DateTime(0).add(duration));
  return formattedTime;
}

void popUntil(BuildContext context, int count) {
  Navigator.of(context).popUntil((route) => count-- <= 0);
}

void pushAndRemoveAll(BuildContext context, String routeName,
    {dynamic arguments}) {
  Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false,
      arguments: arguments);
}

void launchExternalUrl(String url, {Function(bool)? onOpened}) {
  launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)
      .then((hasOpened) => onOpened?.call(hasOpened));
}

double getDeviceWidth(BuildContext context, {double value = 1}) {
  return MediaQuery.of(context).size.width * value;
}

double getDeviceHeight(BuildContext context, {double value = 1}) {
  return MediaQuery.of(context).size.height * value;
}

Future pushWithoutAnimation(BuildContext context, Widget screen) async {
  return await Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: Duration.zero,
      pageBuilder: (context, animation, secondaryAnimation) => screen,
    ),
  );
}

MaterialRoutePush(BuildContext context, Widget builder) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => builder));
}

bool isNotEmpty(dynamic value) {
  if ((value != null && value is! bool && value is! int && value?.isEmpty) ||
      value == null ||
      value == '') {
    return false;
  }
  return true;
}

String getImageType(String path) {
  if (!isNotEmpty(path)) {
    return '';
  }
  if (path.contains('https://')) {
    return ImageType.REMOTE.toString();
  } else if (path.contains('assets/drawable')) {
    return ImageType.ASSET.toString();
  } else {
    return ImageType.LOCAL.toString();
  }
}

OutlineInputBorder generateInputFieldBorder(Color borderColor,
    {double borderRadius = 8}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide: BorderSide(width: 1, color: borderColor),
  );
}

Future<AppVersionModel> getAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  String buildNumber = packageInfo.buildNumber;
  String platform = defaultTargetPlatform == TargetPlatform.iOS
      ? PLATFORM.IOS
      : PLATFORM.ANDROID;
  return AppVersionModel(
    version: version,
    buildNumber: buildNumber,
    platform: platform,
  );
}

String formatTimeOfDay(TimeOfDay time) {
  String formattedTime =
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  return formattedTime;
}

Future<String> get _localPath async {
  final String directory = await downloadFile();
  return directory;
}

Future<File> writeCounter(String bytes, String name, String extension) async {
  try {
    final path = await _localPath;
    final pathName = removeAllSpecialCharacters(name);
    final fileName = pathName.split(' ').join('_');
    File file = File('$path/$fileName.$extension');

    final response = await http.get(Uri.parse(bytes));
    // Write the data in the file you have created
    return await file.writeAsBytes(response.bodyBytes);
  } catch (e) {
    rethrow;
  }
}

Future<String> downloadFile() async {
  try {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    Directory _directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      _directory = Directory("/storage/emulated/0/Download");
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }

    final exPath = _directory.path;
    await Directory(exPath).create(recursive: true);
    return exPath;
  } catch (e) {
    rethrow;
  }
}

String removeAllSpecialCharacters(String input) {
  final RegExp regex = RegExp(r'[^a-zA-Z0-9\s]');
  return input.replaceAll(regex, '');
}

bool startsWithVowel(String word) {
  if (word.trim().isEmpty) return false; // Handle empty or whitespace strings
  return "aeiouAEIOU".contains(word.trim()[0]);
}

String getInitialsForProfileImage(String fullName) {
  if (fullName.isEmpty) return '';

  List<String> nameParts = fullName.split(' ');
  if (nameParts.length >= 2) {
    return '${nameParts[0][0]}${nameParts[nameParts.length - 1][0]}';
  } else if (nameParts.length == 1) {
    return nameParts[0][0];
  }
  return '';
}

String formatPhoneNumber(String number) {
  final nonFormattedNumber = number.replaceAll(RegExp(r'[^\d]'), '');

  if (nonFormattedNumber.length < 10) {
    return nonFormattedNumber;
  }
  String trimNumber = nonFormattedNumber.trim();
  String areaCode = trimNumber.substring(0, 3);
  String firstPart = trimNumber.substring(3, 6);
  String secondPart = trimNumber.substring(6, 10);

  return "($areaCode) $firstPart-$secondPart";
}

String greetingTime() {
  DateTime today = DateTime.now();
  int curHr = today.hour;

  if (curHr < 12) {
    return "Good Morning,";
  } else if (curHr < 17) {
    return "Good Afternoon,";
  } else if (curHr < 21) {
    return "Good Evening,";
  } else {
    return "Good Evening,";
  }
}

String getFullName({
  String? firstName,
  String? middleName,
  String? lastName,
}) {
  String fullname = [firstName, middleName, lastName]
      .where((name) => name != null && name.trim().isNotEmpty)
      .join(' ');
  return fullname.trim();
}

pickImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? photo = await picker.pickImage(
    source: ImageSource.camera,
    imageQuality: 25,
  );
  return await cropImage(photo?.path ?? '');
}

pickImageFromAlbum() async {
  final ImagePicker picker = ImagePicker();
  final XFile? photo =
      await picker.pickImage(source: ImageSource.gallery, imageQuality: 25);
  return await cropImage(photo?.path ?? '');
}

cropImage(path) async {
  final CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: path,
    compressQuality: 1,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      IOSUiSettings(
        title: 'Cropper',
      ),
    ],
  );
  return croppedFile?.path ?? '';
}

bool isKeyboardVisible(BuildContext context) {
  return MediaQuery.of(context).viewInsets.bottom > 0;
}
