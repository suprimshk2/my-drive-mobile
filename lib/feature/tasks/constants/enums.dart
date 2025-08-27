enum QuestionTypeEnum {
  CHECKBOX,
  RADIO,
  TEXTFIELD,
}

// enum TaskTypeEnum {
//   Question,
//   Qnr,
//   Todo,
//   // TODO: verify and add question type enums
//   Signature
// }

class TaskTypes {
  static const String question = "Question";
  static const String qnr = "Qnr";
  static const String todo = "Todo";
  static const String signature = "Signature";
  static const String message = "Message";
}

enum TaskTypeEnum {
  question,
  questionnaire,
  todo,
  signature,
  message,
}

enum TaskStatus {
  DUE('Due', 'DUE'),
  INPROGRESS('In-Progress', 'IN PROGRESS'),
  COMPLETED('Completed', 'COMPLETED'),
  CURRENT('Current', 'CURRENT');

  final String displayName;
  final String value;

  const TaskStatus(this.displayName, this.value);
}
