class TimerModel {
  final int _minutes;
  DateTime _startTime;
  DateTime _endTime;
  bool _notificationSent;  // Add this field

  TimerModel(this._minutes, this._startTime, this._endTime)
      : _notificationSent = false;

  bool isActive() {
    DateTime now = DateTime.now();
    return now.isAfter(_startTime) && now.isBefore(_endTime);
  }

  bool isExpired() {
    return DateTime.now().isAfter(_endTime);
  }

  bool get notificationSent => _notificationSent;  // Add this getter

  set notificationSent(bool value) {
    _notificationSent = value;
  }  // Add this setter

  int get minutes => _minutes;
  DateTime get startTime => _startTime;
  DateTime get endTime => _endTime;
}