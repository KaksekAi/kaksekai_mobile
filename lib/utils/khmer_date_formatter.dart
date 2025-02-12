class KhmerDateFormatter {
  static const Map<int, String> khmerNumbers = {
    0: '០',
    1: '១',
    2: '២',
    3: '៣',
    4: '៤',
    5: '៥',
    6: '៦',
    7: '៧',
    8: '៨',
    9: '៩',
  };

  static const Map<int, String> khmerMonths = {
    1: 'មករា',
    2: 'កុម្ភៈ',
    3: 'មីនា',
    4: 'មេសា',
    5: 'ឧសភា',
    6: 'មិថុនា',
    7: 'កក្កដា',
    8: 'សីហា',
    9: 'កញ្ញា',
    10: 'តុលា',
    11: 'វិច្ឆិកា',
    12: 'ធ្នូ',
  };

  static String toKhmerNumber(int number) {
    return number
        .toString()
        .split('')
        .map((digit) => khmerNumbers[int.parse(digit)])
        .join('');
  }

  static String formatDate(DateTime date) {
    final day = toKhmerNumber(date.day);
    final month = khmerMonths[date.month];
    final year = toKhmerNumber(date.year);
    return 'ថ្ងៃទី $day ខែ$month ឆ្នាំ $year';
  }

  static String formatDateRange(DateTime startDate, DateTime endDate) {
    if (startDate == endDate) {
      return formatDate(startDate);
    }
    return 'ពីថ្ងៃទី ${toKhmerNumber(startDate.day)} ខែ${khmerMonths[startDate.month]} ឆ្នាំ ${toKhmerNumber(startDate.year)} ដល់ថ្ងៃទី ${toKhmerNumber(endDate.day)} ខែ${khmerMonths[endDate.month]} ឆ្នាំ ${toKhmerNumber(endDate.year)}';
  }
}
