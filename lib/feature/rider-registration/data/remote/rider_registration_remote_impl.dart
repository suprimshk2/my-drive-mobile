import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mydrivenepal/data/remote/api_client.dart';
import 'package:mydrivenepal/data/remote/data/model/api_response.dart';
import 'package:mydrivenepal/feature/rider-registration/data/model/rider_registration_request.dart';
import 'package:mydrivenepal/shared/constant/remote_api_constant.dart';
import 'rider_registration_remote.dart';

class RiderRegistrationRemoteImpl implements RiderRegistrationRemote {
  final ApiClient _apiClient;

  RiderRegistrationRemoteImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<ApiResponse> submitRiderRegistration({
    required String userId,
    required RiderRegistrationRequest request,
    Function(int, int)? onSendProgress,
  }) async {
    try {
      // Prepare form data
      final Map<String, dynamic> formData = {};

      // 1. KYC Type - Required field
      formData['kycType'] = 'driver_license';

      // 2. Vehicle Information - Required fields
      if (request.vehicleBrand != null && request.vehicleBrand!.isNotEmpty) {
        formData['vehicleBrand'] = request.vehicleBrand!;
      }

      if (request.vehicleType != null && request.vehicleType!.isNotEmpty) {
        formData['vehicleType'] = request.vehicleType!;
      }

      if (request.registrationPlate != null &&
          request.registrationPlate!.isNotEmpty) {
        formData['vehiclePlate'] = request.registrationPlate!;
      }

      if (request.vehicleProductionYear != null &&
          request.vehicleProductionYear!.isNotEmpty) {
        formData['productionYear'] = request.vehicleProductionYear!;
      }

      // 3. Primary vehicle flag
      formData['isPrimary'] = 'true';

      // 4. Bluebook number - using registration plate as fallback
      if (request.registrationPlate != null &&
          request.registrationPlate!.isNotEmpty) {
        formData['bluebookNumber'] =
            'BB${request.registrationPlate!.replaceAll('-', '')}';
      }

      // 5. Metadata - JSON string with vehicle details
      if (request.metadata != null && request.metadata!.isNotEmpty) {
        formData['metadata'] = request.metadata!;
      } else {
        // Default metadata if not provided
        final defaultMetadata = {
          'color': 'red',
          'fuelType': 'petrol',
        };
        formData['metadata'] = jsonEncode(defaultMetadata);
      }

      // 6. User Information - Optional fields that update user record
      if (request.phoneNumber != null && request.phoneNumber!.isNotEmpty) {
        formData['phoneNumber'] = request.phoneNumber!;
      }
      if (request.dateOfBirth != null && request.dateOfBirth!.isNotEmpty) {
        formData['dateOfBirth'] = request.dateOfBirth!;
      }
      if (request.driverLicenseNumber != null &&
          request.driverLicenseNumber!.isNotEmpty) {
        formData['driverLicenseNumber'] = request.driverLicenseNumber!;
      }

      if (request.driverLicense != null &&
          request.driverLicense!.isNotEmpty &&
          File(request.driverLicense!).existsSync()) {
        formData['driverLicense'] = await MultipartFile.fromFile(
          request.driverLicense!,
          filename: request.driverLicense!.split('/').last,
        );
      }

      if (request.nationalIdFrontPhoto != null &&
          request.nationalIdFrontPhoto!.isNotEmpty &&
          File(request.nationalIdFrontPhoto!).existsSync()) {
        formData['ninCard'] = await MultipartFile.fromFile(
          request.nationalIdFrontPhoto!,
          filename: request.nationalIdFrontPhoto!.split('/').last,
        );
      }

      if (request.vehiclePhoto != null &&
          request.vehiclePhoto!.isNotEmpty &&
          File(request.vehiclePhoto!).existsSync()) {
        formData['vehiclePhoto'] = await MultipartFile.fromFile(
          request.vehiclePhoto!,
          filename: request.vehiclePhoto!.split('/').last,
        );
      }

      if (request.vehicleRegistrationNumberPhoto != null &&
          request.vehicleRegistrationNumberPhoto!.isNotEmpty &&
          File(request.vehicleRegistrationNumberPhoto!).existsSync()) {
        formData['bluebookFile'] = await MultipartFile.fromFile(
          request.vehicleRegistrationNumberPhoto!,
          filename: request.vehicleRegistrationNumberPhoto!.split('/').last,
        );
      }

      if (request.vehicleRegistrationDetailsPhoto != null &&
          request.vehicleRegistrationDetailsPhoto!.isNotEmpty &&
          File(request.vehicleRegistrationDetailsPhoto!).existsSync()) {
        formData['vehicleAdditionalDocuments'] = await MultipartFile.fromFile(
          request.vehicleRegistrationDetailsPhoto!,
          filename: request.vehicleRegistrationDetailsPhoto!.split('/').last,
        );
      }

      // // Add metadata as JSON string
      // if (request.metadata != null) {
      //   formData['metadata'] = request.metadata!;
      // }

      // // Add file uploads
      // if (request.driverLicenseNumber != null &&
      //     request.driverLicenseNumber!.isNotEmpty &&
      //     File(request.driverLicenseNumber!).existsSync()) {
      //   formData['driverLicense'] = await MultipartFile.fromFile(
      //     request.driverLicenseNumber!,
      //     filename: request.driverLicenseNumber,
      //   );
      // }

      // if (request.ninCard != null &&
      //     request.ninCard!.isNotEmpty &&
      //     File(request.ninCard!).existsSync()) {
      //   formData['ninCard'] = await MultipartFile.fromFile(
      //     request.ninCard!,
      //     filename: request.ninCard!.split('/').last,
      //   );
      // }

      // if (request.additionalDocuments != null &&
      //     request.additionalDocuments!.isNotEmpty &&
      //     File(request.additionalDocuments!).existsSync()) {
      //   formData['additionalDocuments'] = await MultipartFile.fromFile(
      //     request.additionalDocuments!,
      //     filename: request.additionalDocuments!.split('/').last,
      //   );
      // }

      // if (request.vehicleRegistrationDetailsPhoto != null &&
      //     request.vehicleRegistrationDetailsPhoto!.isNotEmpty &&
      //     File(request.vehicleRegistrationDetailsPhoto!).existsSync()) {
      //   formData['vehiclePhoto'] = await MultipartFile.fromFile(
      //     request.vehicleRegistrationDetailsPhoto!,
      //     filename: request.vehicleRegistrationDetailsPhoto!.split('/').last,
      //   );
      // }

      // if (request.vehicleRegistrationNumberPhoto != null &&
      //     request.vehicleRegistrationNumberPhoto!.isNotEmpty &&
      //     File(request.vehicleRegistrationNumberPhoto!).existsSync()) {
      //   formData['bluebookFile'] = await MultipartFile.fromFile(
      //     request.vehicleRegistrationNumberPhoto!,
      //     filename: request.vehicleRegistrationNumberPhoto!.split('/').last,
      //   );
      // }

      // if (request.vehicleRegistrationDetailsPhoto != null &&
      //     request.vehicleRegistrationDetailsPhoto!.isNotEmpty &&
      //     File(request.vehicleRegistrationDetailsPhoto!).existsSync()) {
      //   formData['vehicleAdditionalDocuments'] = await MultipartFile.fromFile(
      //     request.vehicleRegistrationDetailsPhoto!,
      //     filename: request.vehicleRegistrationDetailsPhoto!.split('/').last,
      //   );
      // }
      print('formData---------->: $formData');
      // Replace userId placeholder in the endpoint
      final endpoint =
          RemoteAPIConstant.RIDER_REGISTRATION.replaceAll(':userId', userId);

      // Make multipart request
      return await _apiClient.multipartRequest(
        endpoint,
        data: formData,
        // onSendProgress: onSendProgress,
      );

//  Future<UserProfileModel> uploadProfilePicture(String data) async {
//     try {
//       final String apiUrl = RemoteAPIConstant.UPLOAD_PROFILE_IMAGE;

//       final MultipartFile file = await MultipartFile.fromFile(data);

//       final response = await _apiClient.multipartRequest(
//         apiUrl,
//         data: UploadPictureModel(
//           displayPicture: file,
//         ).toJson(),
//       );
//       final aptedResponse = UserProfileModel.fromJson(response.data);
//       return aptedResponse;
//     } catch (e) {
//       throw UnimplementedError();
//     }
//   }
    } catch (e) {
      rethrow;
    }
  }
}
