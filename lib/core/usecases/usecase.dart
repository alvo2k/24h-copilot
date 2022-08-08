import 'package:dartz/dartz.dart';

import '../error/return_types.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
