class TimerModel {
  final int minutes;
  final DateTime startTime;
  final DateTime endTime;
  bool notificationSent;

  TimerModel(this.minutes, this.startTime, this.endTime)
      : notificationSent = false;

  bool isActive() {
    DateTime now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  bool isExpired() {
    return DateTime.now().isAfter(endTime);
  }

  TimerModel copyWith({bool? notificationSent}) {
    return TimerModel(
      minutes,
      startTime,
      endTime,
    )..notificationSent = notificationSent ?? this.notificationSent;
  }

  factory TimerModel.fromJson(Map<String, dynamic> json) {
    try {
      return TimerModel(
        json['minutes'] ?? 0,
        DateTime.parse(json['startTime'] ?? ''),
        DateTime.parse(json['endTime'] ?? ''),
      )..notificationSent = json['notificationSent'] ?? false;
    } catch (e) {
      // Handle deserialization errors
      print('Error deserializing TimerModel: $e');
      return TimerModel(0, DateTime.now(), DateTime.now());
    }
  }
}
