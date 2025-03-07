import 'package:intl/intl.dart';

String localTimeConverter({
  required int timestamp,
  required int timezoneOffset,
}) {
  final localTime = DateFormat('EE, HH:mm').format(
    DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).add(
      Duration(seconds: timezoneOffset),
    ),
  );

  return localTime;
}
