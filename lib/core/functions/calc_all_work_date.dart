Map<String, dynamic> calcAllWorkDate(
    {required Map<String, dynamic> dates, required List dateList}) {
  num hours = 0;
  num minuts = 0;
  num seconds = 0;

  for (var i = 0; i < dateList.length; i++) {
    hours += dates[dateList[i]]['workHours']['h'] ?? 0;
    minuts += dates[dateList[i]]['workHours']['m'] ?? 0;
    if (minuts >= 60) {
      hours += 1;
      minuts -= 60;
    }
    seconds += dates[dateList[i]]['workHours']['s'] ?? 0;
    if (seconds >= 60) {
      minuts += 1;
      seconds -= 60;
    }
  }
  return {
    'h': hours,
    'm': minuts,
    's': seconds,
  };
}
