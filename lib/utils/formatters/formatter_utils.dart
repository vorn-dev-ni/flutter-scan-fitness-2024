import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart';

class FormatterUtils {
  FormatterUtils._();

  /// Formats a number with commas as thousand separators.
  static String formatNumberWithCommas(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) => '${match.group(1)},',
        );
  }

  static String removeJsonString(String input) {
    // Remove backticks and unwanted "json" if present
    return input
        .replaceAll(RegExp(r'```'), '')
        .replaceAll(RegExp(r'json'), '')
        .trim();
  }

  static String countryCodeToFlag(String countryCode) {
    return countryCode
        .toUpperCase()
        .split('')
        .map((char) => String.fromCharCode(char.codeUnitAt(0) + 0x1F1A5))
        .join();
  }

  static double calculateHealthScore({
    required double sleepHours,
    required int steps,
    required double caloriesBurned,
    double sleepWeight = 1.0,
    double stepsWeight = 1.0,
    double caloriesWeight = 1.0,
  }) {
    // Normalize the sleep score (7-9 hours is optimal)
    double sleepScore = _calculateSleepScore(sleepHours);

    // Normalize the step score (Goal: 10,000 steps)
    double stepScore = _calculateStepScore(steps);

    // Normalize the calorie burn score (Goal: 300-500 calories burned)
    double calorieScore = _calculateCalorieScore(caloriesBurned);

    // Weighted average based on user's preferences
    double totalWeight = sleepWeight + stepsWeight + caloriesWeight;
    double weightedHealthScore = ((sleepScore * sleepWeight) +
            (stepScore * stepsWeight) +
            (calorieScore * caloriesWeight)) /
        totalWeight;

    return weightedHealthScore;
  }

  static double _calculateSleepScore(double hours) {
    if (hours < 7) {
      return (hours / 7) * 50; // below target
    } else if (hours > 9) {
      return ((9 - (hours - 9)) / 2) * 50; // above target
    } else {
      return 100; // within optimal range
    }
  }

  static double _calculateStepScore(int steps) {
    const targetSteps = 10000;
    if (steps < targetSteps) {
      return (steps / targetSteps) * 50; // below target
    } else {
      return 100; // on or above target
    }
  }

  static double _calculateCalorieScore(double calories) {
    const minCalories = 300;
    const maxCalories = 500;
    if (calories < minCalories) {
      return (calories / minCalories) * 50; // below target
    } else if (calories > maxCalories) {
      return ((maxCalories - (calories - maxCalories)) / 2) *
          50; // above target
    } else {
      return 100; // within optimal range
    }
  }

  /// Formats a DateTime to a readable string (e.g., "Nov 22, 2024").
  static String formatDate(DateTime date) {
    return '${_monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Converts a duration to a formatted string (e.g., "02:30:15").
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  /// Capitalizes the first letter of a given string.
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  /// Shortens a string to a specified length and adds ellipsis (e.g., "Hello Wo...").
  static String shortenWithEllipsis(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Formats a double value to two decimal places.
  static String formatToTwoDecimalPlaces(double value) {
    return value.toStringAsFixed(2);
  }

  /// Formats a DateTime into a custom pattern (e.g., "22/11/2024").
  static String formatDateCustom(DateTime date, {String separator = '/'}) {
    return '${date.day.toString().padLeft(2, '0')}$separator${date.month.toString().padLeft(2, '0')}$separator${date.year}';
  }

  static String formatAppDateString(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);

      return DateFormat('MMM d, y').format(date);
    } catch (e) {
      return "Invalid date format";
    }
  }

  static String formatDob(DateTime date) {
    DateFormat format = DateFormat("dd-MM-yyyy");
    return format.format(date);
  }

  // Helper for month names
  static const List<String> _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
}
