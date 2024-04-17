import 'package:fpdart/fpdart.dart';

// Type definition for a generic future operation that returns either a Failure or a success value of type T
// Result of async operations where there could be an error or a valid result
typedef FutureEither<T> = Future<Either<Failure, T>>;

// Type definition that represents a future operation which does not need to return a value upon success
typedef FutureVoid = FutureEither<void>;

// Failure class for handling errors
class Failure {
  final String message;
  Failure(this.message);
}
