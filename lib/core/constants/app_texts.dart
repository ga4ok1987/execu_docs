class AppTexts {

  static const String add = 'Додати';
  static const String edit = 'Редагувати';
  static const String cancel = 'Скасувати';
  static const String save = 'Зберегти';
  static const String delete = 'Видалити';
  static const String acceptDelete = 'Підтвердити видалення';

  static const String tittle = 'Підготовка документів для подання до виконавчих органів';
  static const String loadFile = 'Завантажити файл';
  static const String createDocs = 'Створити супровідні';
  static const String settings = 'Налаштування';
  static const String executors = 'Виконавці';
  static const String clearAll = 'Очистити все';
  static const String pathToDocs = 'Шлях до папки з постановами:';
  static const String pathToResults = 'Шлях до папки із супровідними:';
  static const String selectFolder = 'Вибрати папку';

  //debtors
  static const String number = '№';
  static const String fullName = 'ПІБ';
  static const String decree = 'Постанова';
  static const String amount = 'Сума';
  static const String address = 'Адреса';
  static const String region = 'Область';
  static const String regions = 'Області';
  static const String executor = 'Виконавець';

  //region
  static const String addRegion = 'Додати область';
  static const String nameRegion = 'Назва області';
  static const String editRegion = 'Редагувати назву області';
  static String deleteRegionConfirm(String regionName) =>
      'Ви дійсно хочете видалити "$regionName"?';

  //executor
  static const String addExecutor = 'Додати виконавця';
  static const String nameExecutor = 'Назва виконавця';
  static const String mainExecutor = 'Головний виконавець';
  static const String editExecutor = 'Редагувати виконавця';
  static String deleteExecutorConfirm(String executorName) =>
      'Ви дійсно хочете видалити виконавця "$executorName"?';
}