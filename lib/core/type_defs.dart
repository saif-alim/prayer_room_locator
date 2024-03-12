import 'package:fpdart/fpdart.dart';
import 'package:prayer_room_locator/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
