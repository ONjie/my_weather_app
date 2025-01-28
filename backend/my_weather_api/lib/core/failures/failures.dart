import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}

class WeatherApiFailure extends Failure {
  const WeatherApiFailure({required super.message});
}

class OtherFailure extends Failure {
  const OtherFailure({required super.message});
}
