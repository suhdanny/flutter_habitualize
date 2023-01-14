Map<String, dynamic> sortTimelineByDate(Map<String, dynamic> timeline) {
  List keys = List.from(timeline.keys);

  keys.sort((a, b) {
    var dateA = DateTime.parse(a);
    var dateB = DateTime.parse(b);
    return dateB.compareTo(dateA);
  });

  Map<String, dynamic> sortedTimeline = {};
  for (String key in keys) {
    sortedTimeline[key] = timeline[key];
  }
  return sortedTimeline;
}
