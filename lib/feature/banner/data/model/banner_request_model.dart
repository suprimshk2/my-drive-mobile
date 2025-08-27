import 'package:mydrivenepal/data/model/pagination_model.dart';
import 'package:mydrivenepal/shared/util/custom_functions.dart';

class BannerRequestModel extends BasePaginationModel {
  String status;

  BannerRequestModel({
    this.status = 'Active',
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    final Map<String, dynamic> fields = {
      "status": isNotEmpty(status) ? status : null,
    };

    fields.forEach((key, value) {
      if (value != null) {
        data[key] = value;
      }
    });

    return data;
  }
}
