import 'dart:async';
import 'package:mydrivenepal/feature/tasks/data/model/status_model_for_callback.dart';

class TaskCompletionEventBus {
  /*
    TaskCompletionEventBus is must be a singleton class that emits events.
    In this case, task completion event. 

    Since different modules of our app needs to listen to this event,
    we need to make sure that this a singleton class.
  */
  static final TaskCompletionEventBus _instance =
      TaskCompletionEventBus._internal();
  factory TaskCompletionEventBus() => _instance;
  TaskCompletionEventBus._internal();

  final StreamController<StatusModelForCallback> _controller =
      StreamController<StatusModelForCallback>.broadcast();

  Stream<StatusModelForCallback> get stream => _controller.stream;

  void emit(StatusModelForCallback statusModel) {
    _controller.add(statusModel);
  }

  void dispose() {
    _controller.close();
  }
}

// Global instance
final taskCompletionEventBus = TaskCompletionEventBus();
