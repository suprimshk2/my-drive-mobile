enum EpisodeStatus {
  CONFIRMED,
  COMPLETED,
  CLOSED,
  PRELIMINARY,
  CANCELLED,
}

enum MilestoneStatus {
  DUE('Due', 'DUE'),
  INPROGRESS('In-Progress', 'IN PROGRESS'),
  COMPLETED('Completed', 'COMPLETED');

  final String displayName;
  final String value;

  const MilestoneStatus(this.displayName, this.value);
}
