import 'package:mydrivenepal/data/remote/data/model/api_response.dart';
import 'package:mydrivenepal/feature/auth/data/local/auth_local.dart';
import 'package:mydrivenepal/feature/rider-registration/data/model/rider_registration_request.dart';
import 'package:mydrivenepal/feature/rider-registration/data/remote/rider_registration_remote.dart';
import 'rider_registration_repository.dart';

class RiderRegistrationRepositoryImpl implements RiderRegistrationRepository {
  final RiderRegistrationRemote _remote;
  final AuthLocal _authLocal;

  RiderRegistrationRepositoryImpl(
      {required RiderRegistrationRemote remote, required AuthLocal authLocal})
      : _remote = remote,
        _authLocal = authLocal;

  @override
  Future<ApiResponse> submitRiderRegistration({
    required RiderRegistrationRequest request,
    Function(int, int)? onSendProgress,
  }) async {
    return await _remote.submitRiderRegistration(
      userId: await _authLocal.getUserId(),
      request: request,
      onSendProgress: onSendProgress,
    );
  }
}
