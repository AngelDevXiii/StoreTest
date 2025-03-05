class FirestoreServiceFailure implements Exception {
  const FirestoreServiceFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory FirestoreServiceFailure.fromCode(String code) {
    switch (code) {
      case 'deadline-exceeded':
        return const FirestoreServiceFailure(
          'Deadline exceeded, contact support.',
        );
      case 'aborted':
        return const FirestoreServiceFailure(
          'Internal error, service aborted.',
        );
      case 'resource-exhausted':
        return const FirestoreServiceFailure(
          'User account API Cuota exceeded, contact support.',
        );
      case 'invalid-argument':
        return const FirestoreServiceFailure('Invalid arguments by caller.');
      case 'already-exists':
        return const FirestoreServiceFailure('Reference already exists.');
      case 'permission-denied':
        return const FirestoreServiceFailure('Permission denied.');
      case 'unauthenticated':
        return const FirestoreServiceFailure(
          'Permission denied, user unauthorized.',
        );
      case 'unavailable':
        return const FirestoreServiceFailure(
          'Server unavailable. Check internet connection.',
        );
      case 'not-found':
        return const FirestoreServiceFailure('Resource not found.');
      default:
        return const FirestoreServiceFailure();
    }
  }

  final String message;
}
