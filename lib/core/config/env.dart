enum AppEnv { dev, prod, uat }

class Env {
  static const String _raw = String.fromEnvironment('ENV', defaultValue: 'dev');

  static AppEnv get current {
    switch (_raw.toLowerCase()) {
      case 'prod':
        return AppEnv.prod;
      case 'uat':
        return AppEnv.uat;
      default:
        return AppEnv.dev;
    }
  }

  static bool get isDev => current == AppEnv.dev;
  static bool get isProd => current == AppEnv.prod;
  static bool get isUat => current == AppEnv.uat;
}
