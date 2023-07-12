import 'package:checks/checks.dart';
import 'package:simple_date/simple_date.dart';
import 'package:test/test.dart' hide expect;

void main() {
  group('SimpleDate', () {
    test('supports value equality', () {
      check(SimpleDate(2021, 01, 31)).equals(SimpleDate(2021, 01, 31));

      check(SimpleDate(2021, 01, 31))
          .not(it()..equals(SimpleDate(2021, 02, 01)));
    });

    test('has correct hashCode', () {
      check(SimpleDate(2021, 01, 31).hashCode)
          .equals(SimpleDate(2021, 01, 31).hashCode);
    });

    group('.fromDateTime', () {
      test('properly converts DateTime to SimpleDate', () {
        check(SimpleDate.fromDateTime(DateTime(2021, 01, 31)))
            .equals(SimpleDate(2021, 01, 31));
      });
    });

    group('.raw', () {
      test('performs no validation', () {
        const rawInstance = SimpleDate.raw(9999, 99, 99);

        check(rawInstance.year).equals(9999);
        check(rawInstance.month).equals(99);
        check(rawInstance.day).equals(99);
      });
    });

    group('.parse', () {
      test('properly parses String into SimpleDate', () {
        check(SimpleDate.parse('2021-01-31')).equals(SimpleDate(2021, 01, 31));
      });
    });

    test(
      'rolls over to next date when a non-existent date is provided',
      () {
        check(SimpleDate(2021, 01, 32)).equals(SimpleDate(2021, 02, 01));
      },
    );

    test(
      'rolls over to previous date when a non-existent date is provided',
      () {
        check(SimpleDate(2021, 02, 0)).equals(SimpleDate(2021, 01, 31));
      },
    );

    test('today() is correct', () {
      final now = DateTime.now();
      check(SimpleDate.today())
          .equals(SimpleDate(now.year, now.month, now.day));
    });

    test('toDateTime converts instance to a DateTime properly', () {
      check(SimpleDate(2021, 01, 31).toDateTime())
          .equals(DateTime(2021, 01, 31));
    });

    test('isBefore returns true when a date is before another', () {
      check(SimpleDate(2021, 02, 01).isBefore(SimpleDate(2021, 01, 31)))
          .isFalse();
      check(SimpleDate(2021, 01, 31).isBefore(SimpleDate(2021, 01, 31)))
          .isFalse();

      check(SimpleDate(2021, 01, 31).isBefore(SimpleDate(2021, 02, 01)))
          .isTrue();
    });

    test('isAfter returns true when a date is after another', () {
      check(SimpleDate(2021, 01, 31).isAfter(SimpleDate(2021, 02, 01)))
          .isFalse();
      check(SimpleDate(2021, 02, 01).isAfter(SimpleDate(2021, 02, 01)))
          .isFalse();

      check(SimpleDate(2021, 02, 01).isAfter(SimpleDate(2021, 01, 31)))
          .isTrue();
    });

    test('difference returns difference between two dates', () {
      check(SimpleDate(2021, 02, 01).difference(SimpleDate(2021, 01, 31)))
          .equals(const Duration(days: 1));
    });

    group('subtract', () {
      test('subtracts years from date', () {
        check(SimpleDate(2021, 01, 31).subtract(years: 1))
            .equals(SimpleDate(2020, 01, 31));
      });

      test('subtracts months from date', () {
        check(SimpleDate(2021, 02, 01).subtract(months: 1))
            .equals(SimpleDate(2021, 01, 01));
      });

      test('subtracts days from date', () {
        check(SimpleDate(2021, 01, 31).subtract(days: 1))
            .equals(SimpleDate(2021, 01, 30));
      });
    });

    group('add', () {
      test('adds years to date', () {
        check(SimpleDate(2021, 01, 31).add(years: 1))
            .equals(SimpleDate(2022, 01, 31));
      });

      test('adds months to date', () {
        check(SimpleDate(2021, 01, 01).add(months: 1))
            .equals(SimpleDate(2021, 02, 01));
      });

      test('adds days to date', () {
        check(SimpleDate(2021, 01, 30).add(days: 1))
            .equals(SimpleDate(2021, 01, 31));
      });
    });

    group('earliest', () {
      test('returns earliest date between subject and other', () {
        check(SimpleDate(2022).earliest(SimpleDate(2021)))
            .equals(SimpleDate(2021));
      });
    });

    group('latest', () {
      test('returns latest date between subject and other', () {
        check(SimpleDate(2022).latest(SimpleDate(2021)))
            .equals(SimpleDate(2022));
      });
    });

    group('clamp', () {
      test('returns subject when it is between min and max', () {
        check(
          SimpleDate(2021, 01, 15).clamp(
            SimpleDate(2021, 01, 01),
            SimpleDate(2021, 02, 01),
          ),
        ).equals(SimpleDate(2021, 01, 15));
      });

      test('returns start when subject is before start', () {
        check(
          SimpleDate(2021, 01, 01).clamp(
            SimpleDate(2021, 01, 15),
            SimpleDate(2021, 02, 01),
          ),
        ).equals(SimpleDate(2021, 01, 15));
      });

      test('returns end when subject is after end', () {
        check(
          SimpleDate(2021, 02, 01).clamp(
            SimpleDate(2021, 01, 01),
            SimpleDate(2021, 01, 15),
          ),
        ).equals(SimpleDate(2021, 01, 15));
      });
    });

    group('copyWith', () {
      test('only replaces year field when provided', () {
        const before = 2021;
        const after = 2021;

        final original = SimpleDate(before, 01, 01);
        final copied = original.copyWith(year: after);
        final checked = SimpleDate(after, 01, 01);

        check(copied).equals(checked);
      });

      test('only replaces month field when provided', () {
        const before = 01;
        const after = 02;

        final original = SimpleDate(2021, before, 01);
        final copied = original.copyWith(month: after);
        final checked = SimpleDate(2021, after, 01);

        check(copied).equals(checked);
      });

      test('only replaces day field when provided', () {
        const before = 01;
        const after = 02;

        final original = SimpleDate(2021, 01, before);
        final copied = original.copyWith(day: after);
        final checked = SimpleDate(2021, 01, after);

        check(copied).equals(checked);
      });
    });

    test('toString returns date in correct format', () {
      check(SimpleDate(2021, 01, 31).toString()).equals('2021-01-31');
    });

    test('firstDayOfMonth returns first date of month', () {
      check(SimpleDate(2021, 01, 31).firstDayOfMonth)
          .equals(SimpleDate(2021, 01, 01));
    });

    test('lastDayOfMonth returns last date of month', () {
      check(SimpleDate(2021, 01, 01).lastDayOfMonth)
          .equals(SimpleDate(2021, 01, 31));
    });

    test('weekday returns weekday index', () {
      check(SimpleDate(2021, 01, 01).weekday).equals(DateTime.friday);
    });

    test('isWorkingDay returns true when a date falls on a working day', () {
      check(SimpleDate(2021, 01, 01).isWorkingDay).isTrue();
      check(SimpleDate(2021, 01, 02).isWorkingDay).isFalse();
    });

    test('isWeekendDay returns true when a date falls on a weekend day', () {
      check(SimpleDate(2021, 01, 01).isWeekendDay).isFalse();
      check(SimpleDate(2021, 01, 02).isWeekendDay).isTrue();
    });

    test('daysInMonth returns the number of days in the month of the date', () {
      check(SimpleDate(2021, 01, 31).daysInMonth).equals(31);
    });

    test(
      'workingDaysInMonth returns the number of working days '
      'in the month of the date',
      () {
        check(SimpleDate(2021, 01, 31).workingDaysInMonth).equals(21);
      },
    );

    test(
      'workingDaysPassed returns the number of working days '
      'that have passed including the date itself',
      () {
        check(SimpleDate(2021, 01, 15).workingDaysPassed).equals(11);
      },
    );

    test(
      'workingDaysRemaining returns the number of working days '
      'that are remaining excluding the date itself',
      () {
        check(SimpleDate(2021, 01, 15).workingDaysRemaining).equals(10);
      },
    );
  });
}
