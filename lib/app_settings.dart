import 'package:path_provider/path_provider.dart';

class AppSettings {
  factory AppSettings() => _instance;

  AppSettings.internal();

  static final AppSettings _instance = AppSettings.internal();

  static late String basePath;

  Future<void> initPath() async {
    await getApplicationDocumentsDirectory()
        .then((value) => basePath = value.path);
  }
}
