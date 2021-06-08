class NoSuchUserException implements Exception {
  String cause;
  NoSuchUserException(this.cause);
}

void main() {
  try {
    throwException();
  } on NoSuchUserException {}
}

throwException() {
  throw new NoSuchUserException("Couldn't find a user with that ID");
}
