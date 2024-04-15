import 'package:fpdart/fpdart.dart';
import 'package:prayer_room_locator/utils/error-handling/failure.dart';

// Type definition for a generic future operation that returns either a Failure or a success value of type T
// Result of async operations where there could be an error or a valid result
typedef FutureEither<T> = Future<Either<Failure, T>>;

// Type definition that represents a future operation which does not need to return a value upon success
typedef FutureVoid = FutureEither<void>;
