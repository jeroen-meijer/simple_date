import 'package:meta/meta.dart';

/// {@template simple_date}
/// A simple date model with no notion of time.
///
/// Can be used as a simpler alternative to [DateTime], and contains similar
/// APIs.
/// {@endtemplate}
@immutable
class SimpleDate {
  /// {@macro simple_date}
  ///
  /// The given [year], [month], and [day] are passed through a [DateTime] for
  /// validation first.
  factory SimpleDate(int year, [int? month, int? day]) {
    final dateTime = DateTime(year, month ?? 1, day ?? 1);

    return SimpleDate.raw(dateTime.year, dateTime.month, dateTime.day);
  }

  /// Constructs a raw [SimpleDate] with the given [year], [month], and [day].
  ///
  /// Note, this constructor should not usually be used, as none of the values
  /// are validated, and the resulting date may be invalid.
  const SimpleDate.raw(this.year, this.month, this.day);

  /// Constructs a [SimpleDate] from the given [DateTime].
  factory SimpleDate.fromDateTime(DateTime dateTime) {
    return SimpleDate.raw(dateTime.year, dateTime.month, dateTime.day);
  }

  /// Constructs a [SimpleDate] from a [String] using [DateTime.parse].
  factory SimpleDate.parse(String value) {
    return SimpleDate.fromDateTime(DateTime.parse(value));
  }

  /// Constructs a [SimpleDate] for today.
  factory SimpleDate.today() {
    return SimpleDate.fromDateTime(DateTime.now());
  }

  /// The year.
  final int year;

  /// The month.
  final int month;

  /// The day.
  final int day;

  /// Converts this [SimpleDate] to a [DateTime].
  DateTime toDateTime() => DateTime(year, month, day);

  /// Indicates if this date takes place before the [other].
  ///
  /// ```dart
  /// final moonLanding = SimpleDate(1969, 07, 20);
  /// print(moonLanding.isBefore(SimpleDate.today())); // false
  /// ```
  bool isBefore(SimpleDate other) => toDateTime().isBefore(other.toDateTime());

  /// Indicates if this date takes place after the [other].
  ///
  /// ```dart
  /// final moonLanding = SimpleDate(1969, 07, 20);
  /// print(moonLanding.isAfter(SimpleDate.today())); // true
  /// ```
  bool isAfter(SimpleDate other) => toDateTime().isAfter(other.toDateTime());

  /// Returns a [Duration] with the difference when subtracting [other] from
  /// this [SimpleDate] instance.
  ///
  /// ```dart
  /// final before = SimpleDate(2018, 1, 1);
  /// final after = SimpleDate(2018, 1, 2);
  ///
  /// print(before.difference(after)); // Duration(days: 1)
  /// ```
  Duration difference(SimpleDate other) =>
      toDateTime().difference(other.toDateTime());

  /// Creates a copy of this [SimpleDate] instance and subtracts the [year],
  /// [month], and [day] with the given values.
  ///
  /// The [years], [months], and [days] values must be greater than or equal to
  /// 0.
  ///
  /// Note that subtracting months might not always have the desired effect,
  /// since the [day] count can be higher than the resulting date's number of
  /// days, causing it to roll over.
  ///
  /// If you want to add years, months, or days, use the [add] method instead.
  ///
  /// ```dart
  /// final before = SimpleDate(2021, 03, 31);
  /// final after = before.subtract(months: 1); // 2021-02-31 doesn't exist.
  /// print(after); // 2021-03-03
  /// ```
  SimpleDate subtract({
    int years = 0,
    int months = 0,
    int days = 0,
  }) {
    assert(
      years >= 0,
      'The number of years to subtract must be greater than or equal to 0. '
      'If you need to add years, use the add method instead.',
    );
    assert(
        months >= 0,
        'The number of months to subtract must be greater than or equal to 0. '
        'If you need to add months, use the add method instead.');
    assert(
        days >= 0,
        'The number of days to subtract must be greater than or equal to 0. '
        'If you need to add days, use the add method instead.');

    return SimpleDate(
      year - years,
      month - months,
      day - days,
    );
  }

  /// Creates a copy of this [SimpleDate] instance and adds the [year],
  /// [month], and [day] with the given values.
  ///
  /// The [years], [months], and [days] values must be greater than or equal to
  /// 0.
  ///
  /// Note that adding months might not always have the desired effect, since
  /// the [day] count can be higher than the resulting date's number of days,
  /// causing it to roll over.
  ///
  /// If you want to subtract years, months, or days, use the [subtract] method
  /// instead.
  ///
  /// ```dart
  /// final before = SimpleDate(2021, 01, 31);
  /// final after = before.add(months: 1); // 2021-02-31 doesn't exist.
  /// print(after); // 2021-03-03
  /// ```
  SimpleDate add({
    int years = 0,
    int months = 0,
    int days = 0,
  }) {
    assert(
      years >= 0,
      'The number of years to add must be greater than or equal to 0. '
      'If you need to subtract years, use the subtract method instead.',
    );
    assert(
      months >= 0,
      'The number of months to add must be greater than or equal to 0. '
      'If you need to subtract months, use the subtract method instead.',
    );
    assert(
      days >= 0,
      'The number of days to add must be greater than or equal to 0. '
      'If you need to subtract days, use the subtract method instead.',
    );

    return SimpleDate(
      year + years,
      month + months,
      day + days,
    );
  }

  /// Selects the earliest date between this [SimpleDate] and the [other].
  ///
  /// ```dart
  /// final a = SimpleDate(2021, 01, 01);
  /// final b = SimpleDate(2021, 01, 02);
  ///
  /// print(a.earliest(b)); // 2021-01-01
  /// ```
  SimpleDate earliest(SimpleDate other) => isBefore(other) ? this : other;

  /// Selects the latest date between this [SimpleDate] and the [other].
  ///
  /// ```dart
  /// final a = SimpleDate(2021, 01, 01);
  /// final b = SimpleDate(2021, 01, 02);
  ///
  /// print(a.latest(b)); // 2021-01-02
  /// ```
  SimpleDate latest(SimpleDate other) => isAfter(other) ? this : other;

  /// Clamps this [SimpleDate] between [start] and [end].
  ///
  /// If this date is before [start], [start] is returned.
  /// If this date is after [end], [end] is returned.
  /// Otherwise, this date is returned.
  ///
  /// ```dart
  /// final start = SimpleDate(2021, 01, 01);
  /// final end = SimpleDate(2021, 01, 31);
  ///
  /// SimpleDate(2020, 12, 31).clamp(start, end); // 2021-01-01
  /// SimpleDate(2021, 01, 15).clamp(start, end); // 2021-01-15
  /// SimpleDate(2021, 02, 01).clamp(start, end); // 2021-01-31
  /// ```
  SimpleDate clamp(SimpleDate start, SimpleDate end) => isBefore(start)
      ? start
      : isAfter(end)
          ? end
          : this;

  /// Creates a copy of this [SimpleDate] instance and replaces the [year],
  /// [month], and [day] with the given [year], [month], and [day] if provided.
  ///
  /// Tip: Since [SimpleDate] uses [DateTime] under the hood, passing `0` as
  /// the [day] will result in the last day of the previous month. Similarly,
  /// passing `0` as the [month] will result in the last month of the previous
  /// year (but be aware the [day] will be preserved).
  SimpleDate copyWith({
    int? year,
    int? month,
    int? day,
  }) {
    return SimpleDate(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
    );
  }

  /// A [SimpleDate] for the first day of this month.
  SimpleDate get firstDayOfMonth => copyWith(day: 1);

  /// A [SimpleDate] for the last day of this month.
  SimpleDate get lastDayOfMonth => copyWith(month: month + 1, day: 0);

  /// The weekday index for this date.
  ///
  /// See also: [DateTime.weekday].
  ///
  /// ```dart
  /// print(SimpleDate(2021, 01, 31).weekday); // 5 == DateTime.friday
  /// ```
  int get weekday => toDateTime().weekday;

  /// Indicates if this date falls on working day (i.e., a Monday, Tuesday,
  /// Wednesday, Thursday, or Friday).
  bool get isWorkingDay =>
      weekday != DateTime.saturday && weekday != DateTime.sunday;

  /// Indicates if this date falls on a weekend (i.e., a Saturday or Sunday).
  bool get isWeekendDay => !isWorkingDay;

  /// The amount of days in this month.
  int get daysInMonth => lastDayOfMonth.day;

  /// The amount of total working days this month.
  int get workingDaysInMonth {
    return List.generate(daysInMonth, (i) => i)
        .where((dayIndex) => SimpleDate(year, month, dayIndex + 1).isWorkingDay)
        .length;
  }

  /// The amount of working days that have passed this month, including today.
  ///
  /// For example, if today is Monday the 8th, this will return `6`, because a
  /// whole work week plus one working day has passed.
  int get workingDaysPassed {
    return List.generate(day, (i) => i).where((dayIndex) {
      return SimpleDate(year, month, dayIndex + 1).isWorkingDay;
    }).length;
  }

  /// The amount of working days left this month, not including the current day.
  ///
  /// Works by calculating the [workingDaysInMonth] minus [workingDaysPassed].
  int get workingDaysRemaining => workingDaysInMonth - workingDaysPassed;

  /// Returns a string representation of this date in the format `YYYY-MM-DD`.
  @override
  String toString() {
    String pad(int value) => value.toString().padLeft(2, '0');

    return '${pad(year)}-${pad(month)}-${pad(day)}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else {
      return other is SimpleDate &&
          other.year == year &&
          other.month == month &&
          other.day == day;
    }
  }

  @override
  int get hashCode {
    return year.hashCode ^ month.hashCode ^ day.hashCode;
  }
}
