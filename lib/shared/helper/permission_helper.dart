import 'package:permission_handler/permission_handler.dart';

askPermission(List<Permission> permission) async {
  await [
    ...permission,
  ].request();
}
