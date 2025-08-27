import 'package:mydrivenepal/shared/enum/response_state.dart';
import 'package:mydrivenepal/shared/util/error_message_factory.dart';

class Response<ResultType> {
  ResponseState? state;
  ResultType? data;
  String? exception;

  Response({this.state, this.data, this.exception});

  Response.loading() {
    this.state = ResponseState.LOADING;
  }

  Response.complete(this.data) {
    this.state = ResponseState.COMPLETE;
  }

  Response.data(this.data);

  Response.error(dynamic exception) {
    this.state = ResponseState.ERROR;
    this.exception = ErrorMessageFactory.createMessage(exception);
  }

  bool get isLoading => state == ResponseState.LOADING;
  bool get hasCompleted => state == ResponseState.COMPLETE;
  bool get hasError => state == ResponseState.ERROR;

  bool get hasData => data != null;
}
