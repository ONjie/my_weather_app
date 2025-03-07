import 'package:intl/intl.dart';

String timeStampConverter({
  required String format,
  required int timestamp,
}) {
  final result = DateFormat(format).format(
    DateTime.fromMillisecondsSinceEpoch(timestamp * 1000),
  );

  return result;
}
