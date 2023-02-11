class EventDuplicateException implements Exception {
  final String message;

  EventDuplicateException(this.message);
}