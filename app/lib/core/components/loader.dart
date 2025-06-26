class AppLoader {
  static Future<void> handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
  }
}