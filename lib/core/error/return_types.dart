import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([this.prop = const {'id' : 1, 'message' : 'Something went wrong 😬'}]);

  final Map<String, dynamic> prop;

  @override
  List<Object> get props => [prop];
}

class CacheFailure extends Failure {
  const CacheFailure([super.properties]);
}

class Success extends Equatable {
  const Success([this.properties = const <dynamic>[]]);

  final List properties;

  @override
  List<Object> get props => [properties];
}
