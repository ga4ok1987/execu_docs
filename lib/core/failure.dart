abstract class Failure {
  final String message;
  const Failure(this.message);
}

class DuplicateRegionFailure extends Failure {
  const DuplicateRegionFailure() : super("Регіон з такою назвою вже існує");
}

class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = "Помилка бази даних"]);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = "Невідома помилка"]);
}
