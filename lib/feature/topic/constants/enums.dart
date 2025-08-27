enum TopicStatus {
  DUE('Due', 'DUE'),
  INPROGRESS('In-Progress', 'IN PROGRESS'),
  COMPLETED('Completed', 'COMPLETED');

  final String displayName;
  final String value;

  const TopicStatus(this.displayName, this.value);
}
