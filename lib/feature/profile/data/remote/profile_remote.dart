import 'package:mydrivenepal/feature/profile/data/models/user_data.dart';

abstract class ProfileRemote {
  Future<UserDataResponse> getUserData();
}
