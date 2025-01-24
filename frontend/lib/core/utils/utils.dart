List<DateTime> generateWeekDates(int weekOffSet) {
  DateTime today = DateTime.now();
  DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
  startOfWeek.add(Duration(days: weekOffSet * 7));
  return List.generate(
    7,
    (index) => startOfWeek.add(Duration(days: index)),
  );
}
