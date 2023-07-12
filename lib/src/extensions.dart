import 'package:simple_date/simple_date.dart';

/// Extensions on [DateTime] to make it easier to work with [SimpleDate].
extension DateTimeExtensions on DateTime {
  /// Converts this [DateTime] to a [SimpleDate].
  ///
  /// ```dart
  /// final moonLanding = DateTime(1969, 07, 20);
  /// print(moonLanding.toSimpleDate()); // SimpleDate(1969, 07, 20)
  /// ```
  SimpleDate toSimpleDate() => SimpleDate.fromDateTime(this);
}
