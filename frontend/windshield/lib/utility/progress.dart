class HelperProgress {
  static double getPercent(double current, double target) {
    final progress = current / target;
    if (progress >= 1) return 1;
    return progress;
  }
}
