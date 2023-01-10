bool isDateAfterToday(DateTime selectedDay) {
  DateTime now = DateTime.now();
  if (selectedDay.year > now.year) {
    return true;
  } else if (selectedDay.year == now.year) {
    if (selectedDay.month > now.month) {
      return true;
    } else if (selectedDay.month == now.month) {
      if (selectedDay.day > now.day) {
        return true;
      }
    }
  }
  return false;
}
