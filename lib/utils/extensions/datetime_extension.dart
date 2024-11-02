extension DatetimeExtension on DateTime {
  String formattedDate() {
    return "$day / $month / $year";
  }

  bool compareDate(DateTime date) {
    return (day == date.day && month == date.month && year == date.year);
  }
}
