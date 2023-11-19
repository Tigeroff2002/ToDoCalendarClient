class EventAppointment{
  late DateTime startTime;
  late DateTime endTime;
  late String subject;

  EventAppointment(String start, String difference, String caption){
    startTime = DateTime.parse(start);
    String time = difference;
    List<String> timeParts = time.split(':');
    Duration duration = Duration(
        hours: int.parse(timeParts[0]),
        minutes: int.parse(timeParts[1]),
        seconds: int.parse(timeParts[2]));
    endTime = startTime.add(duration);
    subject = caption;
  }
}