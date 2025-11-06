/// Extension methods on String for common operations
extension StringExtensions on String {
  /// Check if string is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Check if string is not null and not empty
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitalize first letter of each word
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.capitalize)
        .join(' ');
  }

  /// Convert to title case
  String get toTitleCase => capitalizeWords;

  /// Check if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if string is a valid phone number
  bool get isValidPhone {
    final phoneRegex = RegExp(r'^\+?[\d\s-()]+$');
    return phoneRegex.hasMatch(this) && length >= 10;
  }

  /// Check if string is a valid URL
  bool get isValidUrl {
    final urlRegex = RegExp(
      r'^(http|https):\/\/[^\s$.?#].[^\s]*$',
      caseSensitive: false,
    );
    return urlRegex.hasMatch(this);
  }

  /// Check if string contains only numbers
  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  /// Check if string contains only letters
  bool get isAlphabetic {
    final alphabeticRegex = RegExp(r'^[a-zA-Z]+$');
    return alphabeticRegex.hasMatch(this);
  }

  /// Check if string contains only alphanumeric characters
  bool get isAlphanumeric {
    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
    return alphanumericRegex.hasMatch(this);
  }

  /// Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Remove extra whitespace (multiple spaces to single space)
  String get removeExtraWhitespace => replaceAll(RegExp(r'\s+'), ' ').trim();

  /// Truncate string to specified length
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }

  /// Truncate string to specified length from the middle
  String truncateMiddle(int maxLength, {String separator = '...'}) {
    if (length <= maxLength) return this;
    final charsToShow = maxLength - separator.length;
    final frontChars = (charsToShow / 2).ceil();
    final backChars = (charsToShow / 2).floor();
    return '${substring(0, frontChars)}$separator${substring(length - backChars)}';
  }

  /// Reverse string
  String get reverse => split('').reversed.join();

  /// Convert to int
  int? get toInt => int.tryParse(this);

  /// Convert to double
  double? get toDouble => double.tryParse(this);

  /// Convert to DateTime
  DateTime? get toDateTime => DateTime.tryParse(this);

  /// Check if string is palindrome
  bool get isPalindrome => this == reverse;

  /// Count occurrences of a substring
  int countOccurrences(String substring) {
    if (substring.isEmpty) return 0;
    return split(substring).length - 1;
  }

  /// Mask string (for sensitive data)
  String mask({
    int visibleStart = 0,
    int visibleEnd = 0,
    String maskChar = '*',
  }) {
    if (length <= visibleStart + visibleEnd) return this;

    final start = substring(0, visibleStart);
    final end = substring(length - visibleEnd);
    final masked = maskChar * (length - visibleStart - visibleEnd);

    return '$start$masked$end';
  }

  /// Mask email (show first char and domain)
  String get maskEmail {
    if (!isValidEmail) return this;
    final parts = split('@');
    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 2) {
      return '${username[0]}***@$domain';
    }

    return '${username[0]}${'*' * (username.length - 2)}${username[username.length - 1]}@$domain';
  }

  /// Mask phone number (show last 4 digits)
  String get maskPhone {
    if (length <= 4) return this;
    return '${'*' * (length - 4)}${substring(length - 4)}';
  }

  /// Convert to snake_case
  String get toSnakeCase {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^_'), '');
  }

  /// Convert to camelCase
  String get toCamelCase {
    final words = split(RegExp(r'[_\s-]+'));
    if (words.isEmpty) return this;

    return words.first.toLowerCase() +
        words.skip(1).map((word) => word.capitalize).join();
  }

  /// Convert to PascalCase
  String get toPascalCase {
    final words = split(RegExp(r'[_\s-]+'));
    return words.map((word) => word.capitalize).join();
  }

  /// Convert to kebab-case
  String get toKebabCase {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '-${match.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^-'), '');
  }

  /// Remove HTML tags
  String get removeHtmlTags {
    return replaceAll(RegExp(r'<[^>]*>'), '');
  }

  /// Get initials (first letter of each word)
  String get initials {
    if (isEmpty) return '';
    final words = trim().split(RegExp(r'\s+'));
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }
    return words
        .take(2)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();
  }

  /// Check if string matches a pattern
  bool matches(String pattern) {
    return RegExp(pattern).hasMatch(this);
  }

  /// Extract all numbers from string
  List<int> get extractNumbers {
    return RegExp(r'\d+')
        .allMatches(this)
        .map((match) => int.parse(match.group(0)!))
        .toList();
  }

  /// Format as currency (simple)
  String toCurrency({String symbol = '\$'}) {
    final number = toDouble;
    if (number == null) return this;
    return '$symbol${number.toStringAsFixed(2)}';
  }

  /// Add thousand separators
  String get withThousandSeparators {
    final number = toDouble;
    if (number == null) return this;

    final parts = number.toString().split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    final withSeparators = integerPart.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );

    return '$withSeparators$decimalPart';
  }

  /// Wrap text in quotes
  String get quote => '"$this"';

  /// Wrap text in single quotes
  String get singleQuote => "'$this'";

  /// Check if string is blank (empty or whitespace)
  bool get isBlank => trim().isEmpty;

  /// Check if string is not blank
  bool get isNotBlank => !isBlank;
}

/// Extension on nullable String
extension NullableStringExtensions on String? {
  /// Check if string is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Check if string is not null and not empty
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Check if string is null or blank
  bool get isNullOrBlank => this == null || this!.isBlank;

  /// Check if string is not null and not blank
  bool get isNotNullOrBlank => !isNullOrBlank;

  /// Get value or default
  String orDefault(String defaultValue) => this ?? defaultValue;

  /// Get value or empty string
  String get orEmpty => this ?? '';
}
