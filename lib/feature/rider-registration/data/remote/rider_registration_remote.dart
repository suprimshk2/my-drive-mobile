import 'package:mydrivenepal/data/remote/api_client.dart';
import 'package:mydrivenepal/data/remote/data/model/api_response.dart';
import 'package:mydrivenepal/feature/rider-registration/data/model/rider_registration_request.dart';

abstract class RiderRegistrationRemote {
  Future<ApiResponse> submitRiderRegistration({
    required String userId,
    required RiderRegistrationRequest request,
    Function(int, int)? onSendProgress,
  });
}
