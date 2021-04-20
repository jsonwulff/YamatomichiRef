class NoSuchUserException implements Exception {
  String cause;
  NoSuchUserException(this.cause);
}

void main() {
  try {
    throwException();
  } on NoSuchUserException {
    print("Couldn't find a user with that ID");
  }
}

throwException() {
  throw new NoSuchUserException("Couldn't find a user with that ID");
}
