class Topic {
  final int? id;
  final String? topic;
  final String? patientTopic;
  final int? escalationDays;
  final DateTime? createdDate;
  final String? status;
  final int? sequence;
  final String? uuid;
  final bool? isActive;
  final String? milestoneStatus;
  final int? milestoneId;
  final List<Task>? tasks;

  Topic({
    this.id,
    this.topic,
    this.patientTopic,
    this.escalationDays,
    this.createdDate,
    this.status,
    this.sequence,
    this.uuid,
    this.isActive,
    this.milestoneStatus,
    this.milestoneId,
    this.tasks,
  });

  Topic copyWith({
    int? id,
    String? topic,
    String? patientTopic,
    int? escalationDays,
    DateTime? createdDate,
    String? status,
    int? sequence,
    String? uuid,
    bool? isActive,
    String? milestoneStatus,
    int? milestoneId,
    List<Task>? tasks,
  }) {
    return Topic(
      id: id ?? this.id,
      topic: topic ?? this.topic,
      patientTopic: patientTopic ?? this.patientTopic,
      escalationDays: escalationDays ?? this.escalationDays,
      createdDate: createdDate ?? this.createdDate,
      status: status ?? this.status,
      sequence: sequence ?? this.sequence,
      uuid: uuid ?? this.uuid,
      isActive: isActive ?? this.isActive,
      milestoneStatus: milestoneStatus ?? this.milestoneStatus,
      milestoneId: milestoneId ?? this.milestoneId,
      tasks: tasks ?? this.tasks,
    );
  }

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      topic: json['topic'],
      patientTopic: json['patientTopic'],
      escalationDays: json['escalationDays'],
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : null,
      status: json['status'],
      sequence: json['sequence'],
      uuid: json['uuid'],
      isActive: json['isActive'],
      milestoneStatus: json['milestoneStatus'],
      milestoneId: json['milestoneId'],
      tasks:
          (json['tasks'] as List?)?.map((task) => Task.fromJson(task)).toList(),
    );
  }

  static List<Topic> fromJsonList(dynamic json) =>
      (json as List?)?.map((x) => Topic.fromJson(x)).toList() ?? [];
}

class Task {
  final int? id;
  final String? name;
  final int? taskId;
  final String? instruction;
  final String? taskTodoLink;
  final bool? isAcknowledgedRequired;
  final String? assignedBy;
  final bool? isHighPriority;
  final String? assignedTo;
  final bool? isDependent;
  final bool? isActivated;
  final String? status;
  final int? escalationDays;
  final int? sequence;
  final String? uuid;
  final String? parentUuid;
  final bool? isActive;
  final String? documentDisplayName;
  final String? assignedByRole;
  final String? assignedToRole;
  final String? completionReason;
  final String? supervisorOf;
  final String? supervisorOfId;
  final String? type;
  final bool? isNotifiableToAssignor;
  final bool? isNotifiableToAssignee;
  final String? docuSignTemplateId;
  final String? docuSignEnvelopeId;
  final bool? isDocumentSigned;
  final Question? questions;
  final Qnrs? qnrs;
  final String? messages;
  final num? episodeId;
  final num? milestoneId;
  final num? topicId;
  final num? userId;

  Task({
    this.id,
    this.name,
    this.taskId,
    this.instruction,
    this.taskTodoLink,
    this.isAcknowledgedRequired,
    this.assignedBy,
    this.isHighPriority,
    this.assignedTo,
    this.isDependent,
    this.isActivated,
    this.status,
    this.escalationDays,
    this.sequence,
    this.uuid,
    this.parentUuid,
    this.isActive,
    this.documentDisplayName,
    this.assignedByRole,
    this.assignedToRole,
    this.completionReason,
    this.supervisorOf,
    this.supervisorOfId,
    this.type,
    this.isNotifiableToAssignor,
    this.isNotifiableToAssignee,
    this.docuSignTemplateId,
    this.docuSignEnvelopeId,
    this.isDocumentSigned,
    this.questions,
    this.qnrs,
    this.messages,
    this.episodeId,
    this.milestoneId,
    this.topicId,
    this.userId,
  });

  Task copyWith({
    int? id,
    String? name,
    int? taskId,
    String? instruction,
    String? taskTodoLink,
    bool? isAcknowledgedRequired,
    String? assignedBy,
    bool? isHighPriority,
    String? assignedTo,
    bool? isDependent,
    bool? isActivated,
    String? status,
    int? escalationDays,
    int? sequence,
    String? uuid,
    String? parentUuid,
    bool? isActive,
    String? documentDisplayName,
    String? assignedByRole,
    String? assignedToRole,
    String? completionReason,
    String? supervisorOf,
    String? supervisorOfId,
    String? type,
    bool? isNotifiableToAssignor,
    bool? isNotifiableToAssignee,
    String? docuSignTemplateId,
    String? docuSignEnvelopeId,
    bool? isDocumentSigned,
    Question? questions,
    Qnrs? qnrs,
    String? messages,
    num? episodeId,
    num? milestoneId,
    num? topicId,
    num? userId,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      taskId: taskId ?? this.taskId,
      instruction: instruction ?? this.instruction,
      taskTodoLink: taskTodoLink ?? this.taskTodoLink,
      isAcknowledgedRequired:
          isAcknowledgedRequired ?? this.isAcknowledgedRequired,
      assignedBy: assignedBy ?? this.assignedBy,
      isHighPriority: isHighPriority ?? this.isHighPriority,
      assignedTo: assignedTo ?? this.assignedTo,
      isDependent: isDependent ?? this.isDependent,
      isActivated: isActivated ?? this.isActivated,
      status: status ?? this.status,
      escalationDays: escalationDays ?? this.escalationDays,
      sequence: sequence ?? this.sequence,
      uuid: uuid ?? this.uuid,
      parentUuid: parentUuid ?? this.parentUuid,
      isActive: isActive ?? this.isActive,
      documentDisplayName: documentDisplayName ?? this.documentDisplayName,
      assignedByRole: assignedByRole ?? this.assignedByRole,
      assignedToRole: assignedToRole ?? this.assignedToRole,
      completionReason: completionReason ?? this.completionReason,
      supervisorOf: supervisorOf ?? this.supervisorOf,
      supervisorOfId: supervisorOfId ?? this.supervisorOfId,
      type: type ?? this.type,
      isNotifiableToAssignor:
          isNotifiableToAssignor ?? this.isNotifiableToAssignor,
      isNotifiableToAssignee:
          isNotifiableToAssignee ?? this.isNotifiableToAssignee,
      docuSignTemplateId: docuSignTemplateId ?? this.docuSignTemplateId,
      docuSignEnvelopeId: docuSignEnvelopeId ?? this.docuSignEnvelopeId,
      isDocumentSigned: isDocumentSigned ?? this.isDocumentSigned,
      questions: questions ?? this.questions,
      qnrs: qnrs ?? this.qnrs,
      messages: messages ?? this.messages,
      episodeId: episodeId ?? this.episodeId,
      milestoneId: milestoneId ?? this.milestoneId,
      topicId: topicId ?? this.topicId,
      userId: userId ?? this.userId,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      taskId: json['taskId'],
      messages: json['messages'],
      instruction: json['instruction'],
      taskTodoLink: json['taskTodoLink'],
      isAcknowledgedRequired: json['isAcknowledgedRequired'],
      assignedBy: json['assignedBy'],
      isHighPriority: json['isHighPriority'],
      assignedTo: json['assignedTo'],
      isDependent: json['isDependent'],
      isActivated: json['isActivated'],
      status: json['status'],
      escalationDays: json['escalationDays'],
      sequence: json['sequence'],
      uuid: json['uuid'],
      parentUuid: json['parentUuid'],
      isActive: json['isActive'],
      documentDisplayName: json['documentDisplayName'],
      assignedByRole: json['assignedByRole'],
      assignedToRole: json['assignedToRole'],
      completionReason: json['completionReason'],
      supervisorOf: json['supervisorOf'],
      supervisorOfId: json['supervisorOfId'],
      type: json['type'],
      isNotifiableToAssignor: json['isNotifiableToAssignor'],
      isNotifiableToAssignee: json['isNotifiableToAssignee'],
      docuSignTemplateId: json['docuSignTemplateId'],
      docuSignEnvelopeId: json['docuSignEnvelopeId'],
      isDocumentSigned: json['isDocumentSigned'],
      questions: json['questions'] != null
          ? Question.fromJson(json['questions'])
          : null,
      qnrs: json['qnrs'] != null ? Qnrs.fromJson(json['qnrs']) : null,
      episodeId: json['episodeId'],
      milestoneId: json['milestoneId'],
      topicId: json['topicId'],
      userId: json['userId'],
    );
  }

  static List<Task> fromJsonList(dynamic json) =>
      List<Task>.from(json.map((x) => Task.fromJson(x)));
}

class Question {
  final int? id;
  final int? questionTypeId;
  final String? question;
  final String? questionHelp;
  final String? description;

  final int? sequence;
  final String? uuid;
  final String? parentUuid;
  final String? status;
  final String? groupCode;
  final List<QuestionOption>? questionOptions;
  final QuestionType? questionTypes;
  final List<AnswerOption>? ansOpt;

  Question({
    this.id,
    this.questionTypeId,
    this.question,
    this.questionHelp,
    this.description,
    this.sequence,
    this.uuid,
    this.parentUuid,
    this.status,
    this.groupCode,
    this.questionOptions,
    this.questionTypes,
    this.ansOpt,
  });

  Question copyWith({
    int? id,
    int? questionTypeId,
    String? question,
    String? questionHelp,
    String? description,
    int? sequence,
    String? uuid,
    String? parentUuid,
    String? status,
    String? groupCode,
    List<QuestionOption>? questionOptions,
    QuestionType? questionTypes,
    List<AnswerOption>? ansOpt,
  }) {
    return Question(
      id: id ?? this.id,
      questionTypeId: questionTypeId ?? this.questionTypeId,
      question: question ?? this.question,
      questionHelp: questionHelp ?? this.questionHelp,
      description: description ?? this.description,
      sequence: sequence ?? this.sequence,
      uuid: uuid ?? this.uuid,
      parentUuid: parentUuid ?? this.parentUuid,
      status: status ?? this.status,
      groupCode: groupCode ?? this.groupCode,
      questionOptions: questionOptions ?? this.questionOptions,
      questionTypes: questionTypes ?? this.questionTypes,
      ansOpt: ansOpt ?? this.ansOpt,
    );
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      questionTypeId: json['questionTypeId'],
      question: json['ques'] ?? json['question'],
      questionHelp: json['questionHelp'],
      description: json['description'],
      sequence: json['sequence'],
      uuid: json['uuid'],
      parentUuid: json['parentUuid'],
      status: json['status'],
      groupCode: json['groupCode'],
      questionOptions: (json['questionOptions'] as List?)
          ?.map((e) => QuestionOption.fromJson(e))
          .toList(),
      questionTypes: json['questionTypes'] != null
          ? QuestionType.fromJson(json['questionTypes'])
          : null,
      ansOpt: (json['ansOpt'] as List?)
          ?.map((e) => AnswerOption.fromJson(e))
          .toList(),
    );
  }
}

class QuestionOption {
  final int? id;
  final int? questionId;
  final String? optionValue;
  final String? description;
  final bool? triggerTask;
  final String? taskTodoId;
  final String? taskSignatureId;
  final String? taskMessageId;
  final String? taskQuestionId;
  final String? taskQnrsId;
  final String? uuid;
  final String? taskTodoUuid;
  final String? taskSignatureUuid;
  final String? taskMessageUuid;
  final String? taskQuesUuid;
  final String? taskQnrsUuid;
  final String? questionUuid;
  final String? severity;
  final Task? subQuestion;

  QuestionOption({
    this.id,
    this.questionId,
    this.optionValue,
    this.description,
    this.triggerTask,
    this.taskTodoId,
    this.taskSignatureId,
    this.taskMessageId,
    this.taskQuestionId,
    this.taskQnrsId,
    this.uuid,
    this.taskTodoUuid,
    this.taskSignatureUuid,
    this.taskMessageUuid,
    this.taskQuesUuid,
    this.taskQnrsUuid,
    this.questionUuid,
    this.severity,
    this.subQuestion,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['id'],
      questionId: json['questionId'],
      optionValue: json['optionValue'],
      description: json['description'],
      triggerTask: json['triggerTask'],
      taskTodoId: json['taskTodoId'],
      taskSignatureId: json['taskSignatureId'],
      taskMessageId: json['taskMessageId'],
      taskQuestionId: json['taskQuestionId'],
      taskQnrsId: json['taskQnrsId'],
      uuid: json['uuid'],
      taskTodoUuid: json['taskTodoUuid'],
      taskSignatureUuid: json['taskSignatureUuid'],
      taskMessageUuid: json['taskMessageUuid'],
      taskQuesUuid: json['taskQuesUuid'],
      taskQnrsUuid: json['taskQnrsUuid'],
      questionUuid: json['questionUuid'],
      severity: json['severity'],
      subQuestion: json['subQuestion'] != null
          ? Task.fromJson(json['subQuestion'])
          : null,
    );
  }
}

class QuestionType {
  final int? id;
  final String? name;
  final String? description;
  final String? code;

  QuestionType({
    this.id,
    this.name,
    this.description,
    this.code,
  });

  factory QuestionType.fromJson(Map<String, dynamic> json) {
    return QuestionType(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      code: json['code'],
    );
  }
}

class AnswerOption {
  final num? id;
  final num? episodeId;
  final num? questionId;
  final num? userId;
  final num? answerOptionId;
  final String? answer;
  final String? status;

  AnswerOption({
    this.id,
    this.episodeId,
    this.questionId,
    this.userId,
    this.answerOptionId,
    this.answer,
    this.status,
  });

  factory AnswerOption.fromJson(Map<String, dynamic> json) {
    return AnswerOption(
      id: json['id'],
      episodeId: json['episodeId'],
      questionId: json['questionId'],
      userId: json['userId'],
      answerOptionId: json['answerOptionId'],
      answer: json['answer'],
      status: json['status'],
    );
  }
}

class Qnrs {
  final int? id;
  final String? name;
  final String? description;
  final int? sequence;
  final String? uuid;
  final bool? isActive;
  final bool? isHighPriority;
  final List<QnrsQues>? qnrsQues;

  Qnrs({
    this.id,
    this.name,
    this.description,
    this.sequence,
    this.uuid,
    this.isActive,
    this.isHighPriority,
    this.qnrsQues,
  });

  Qnrs copyWith({
    int? id,
    String? name,
    String? description,
    int? sequence,
    String? uuid,
    bool? isActive,
    bool? isHighPriority,
    List<QnrsQues>? qnrsQues,
  }) {
    return Qnrs(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      sequence: sequence ?? this.sequence,
      uuid: uuid ?? this.uuid,
      isActive: isActive ?? this.isActive,
      isHighPriority: isHighPriority ?? this.isHighPriority,
      qnrsQues: qnrsQues ?? this.qnrsQues,
    );
  }

  factory Qnrs.fromJson(Map<String, dynamic> json) {
    return Qnrs(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      sequence: json['sequence'],
      uuid: json['uuid'],
      isActive: json['isActive'],
      isHighPriority: json['isHighPriority'],
      qnrsQues: (json['qnrsQues'] as List?)
          ?.map((e) => QnrsQues.fromJson(e))
          .toList(),
    );
  }
}

class QnrsQues {
  final int? id;
  final int? questionnaireId;
  final int? questionId;
  final Question? question;

  QnrsQues({
    this.id,
    this.questionnaireId,
    this.questionId,
    this.question,
  });

  QnrsQues copyWith({
    int? id,
    int? questionnaireId,
    int? questionId,
    Question? question,
  }) {
    return QnrsQues(
      id: id ?? this.id,
      questionnaireId: questionnaireId ?? this.questionnaireId,
      questionId: questionId ?? this.questionId,
      question: question ?? this.question,
    );
  }

  factory QnrsQues.fromJson(Map<String, dynamic> json) {
    return QnrsQues(
      id: json['id'],
      questionnaireId: json['questionnaireId'],
      questionId: json['questionId'],
      question:
          json['question'] != null ? Question.fromJson(json['question']) : null,
    );
  }
}
