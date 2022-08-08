import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([this.properties = const <dynamic>[]]);

  final List properties;

  @override
  List<Object> get props => [properties];
}

class Success extends Equatable {
  const Success([this.properties = const <dynamic>[]]);

  final List properties;

  @override
  List<Object> get props => [properties];
}
