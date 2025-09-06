import 'package:mydrivenepal/data/remote/data/model/api_response.dart';
import 'package:mydrivenepal/feature/rider-registration/data/model/rider_registration_request.dart';

abstract class RiderRegistrationRepository {
  Future<ApiResponse> submitRiderRegistration({
    required RiderRegistrationRequest request,
    Function(int, int)? onSendProgress,
  });
}
