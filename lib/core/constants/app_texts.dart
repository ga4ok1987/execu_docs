class AppTexts {
  static const String appName = 'Створення супровідних документів для виконавців';

  static const String add = 'Додати';
  static const String edit = 'Редагувати';
  static const String cancel = 'Скасувати';
  static const String save = 'Зберегти';
  static const String delete = 'Видалити';
  static const String accept = 'Підтвердити';
  static const String acceptDelete = 'Підтвердити видалення';

  static const String error = 'Помилка';
  static String errorString(String error) =>
      'Помилка: "$error"';
  static const String ok = 'Ок';
  static const String empty = '';

  static const String tittle =
      'Підготовка документів для подання до виконавчих органів';
  static const String loadFiles = 'Завантажити постанови';
  static const String createDocs = 'Створити супровідні';
  static const String settings = 'Налаштування';
  static const String executors = 'Виконавці';
  static const String clearAll = 'Очистити все';
  static const String pathToDocs = 'Шлях до папки з постановами:';
  static const String pathToResults = 'Шлях до папки із супровідними:';
  static const String selectFolder = 'Вибрати папку';
  static const String selectFolderFirst = 'Спочатку вибріть папку';
  static const String folderNotSelected = 'Папку не вибрано';

  //debtors
  static const String addDebtor = 'Додати боржника';
  static const String editDebtor = 'Змінити дані боржника';
  static const String number = '№';
  static const String fullName = 'ПІБ';
  static const String fullNameIsRequired = 'Поле ПІБ є обов’язковим';
  static const String decree = 'Постанова';
  static const String amount = 'Сума';
  static const String address = 'Адреса';
  static const String region = 'Область';
  static const String regions = 'Області';
  static const String executor = 'Виконавець';
  static const String dropdownNotSelected = 'не вибрано';
  static const String notSelected = 'не вибрано';

  //region
  static const String selectRegion = 'Виберіть область';
  static const String addRegion = 'Додати область';
  static const String nameRegion = 'Назва області';
  static const String editRegion = 'Редагувати назву області';
  static const String addNameRegion = 'Введіть назву області';
  static const String regionExist = 'Область з такою назвою вже існує';
  static const String noRegions = 'Список областей пустий';
  static const String nameRegionEmpty = 'Назва області не може бути порожньою';
  static const String alertDelete =
      'Увага, з видаленням області, також будуть видалені виконавці в цій області';

  static String deleteRegionConfirm(String regionName) =>
      'Ви дійсно хочете видалити "$regionName"?';

  //executor
  static const String addExecutor = 'Додати виконавця';
  static const String nameExecutor = 'Назва виконавця';
  static const String mainExecutor = 'Головний виконавець';
  static const String editExecutor = 'Редагувати виконавця';
  static const String executorsNotFound = 'Виконавців ще не додано';
  static const String nameExecutorEmpty = 'Назва виконавця не може бути порожньою';
  static const String addressExecutorEmpty = 'Адреса виконавця не може бути порожньою';
  static const String selectedExecutor = 'Вибраний виконавець';
  static const String selectExecutor = 'Виберіть виконавеця';


  static String deleteExecutorConfirm(String executorName) =>
      'Ви дійсно хочете видалити виконавця "$executorName"?';
  static String executorsInRegion(String executorName) =>
      'Виконавчі служби \n"$executorName"';

  static const String fine600 = '(шістсот) гривень';
  static const String fine680 = '(шістсот вісімдесят) гривень';
  static const String fine1360 = '(одна тисяча триста шістдесят) гривень';
  static const String uah = ' гривень';

  static const String clearAllAlert =
      'Увага, всі дані порушників \n будуть стерті';

  static String deleteDebtorConfirm(String debtorName) =>
      'Ви дійсно хочете видалити боржника "$debtorName"?';

  static const String deleteAlert = 'Бажаєте видалити дані?';
  static const String firstSelectDebtor = 'Спочатку виберіть боржника';
}
