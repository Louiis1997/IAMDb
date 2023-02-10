class EventHelpers {
  static String formatEventStatus(String status) {
    switch (status) {
      case 'EventStatus.live':
        return 'Live event';
      case 'EventStatus.upcoming':
        return 'Upcoming event';
      case 'EventStatus.past':
        return 'Past event';
      default:
        throw Exception('Unknown event status : $status');
    }
  }
}
