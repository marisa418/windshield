class HelperProgress {
  static double getPercent(double current, double target) {
    if (target <= 0 || current < 0) return 0;
    final progress = current / target;
    if (progress >= 1) return 1;
    return progress;
  }
}
