import "package:intl/intl.dart";

class NumberFormatTool {
  static String formatPrice(double nb) {
    NumberFormat formatDecimalPrice = NumberFormat("##0.00", "fr");
    NumberFormat formatIntegerPrice = NumberFormat("##0.#", "fr");

    if (!nb.isNaN)
      return (nb.toInt() != nb
          ? formatDecimalPrice.format(nb)
          : formatIntegerPrice.format(nb));
    return (null);
  }

  static String formatRating(double nb) {
    NumberFormat formatDecimalRating = NumberFormat("##0.0#", "en");
    NumberFormat formatIntegerRating = NumberFormat("##0.#", "en");

    if (!nb.isNaN)
      return (nb.toInt() != nb
          ? formatDecimalRating.format(nb)
          : formatIntegerRating.format(nb));
    return (null);
  }

  static String formatDate({int day, int month}) {
    NumberFormat formatDayMonth = NumberFormat("00");

    if (day != null) {
      return (formatDayMonth.format(day));
    }
    if (month != null) {
      return (formatDayMonth.format(month));
    }
    return (null);
  }
}
