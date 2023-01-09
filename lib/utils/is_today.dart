bool isDateAfterToday(DateTime selectedDay) {
  DateTime today = DateTime.now();

  return selectedDay.isAfter(today);
}
