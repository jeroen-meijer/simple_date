import 'package:simple_date/simple_date.dart';
import 'package:test/test.dart';

void main() {
  group('SimpleDate', () {
    test('supports value equality', () {
      expect(
        SimpleDate(2021, 01, 31),
        equals(SimpleDate(2021, 01, 31)),
      );

      expect(
        SimpleDate(2021, 01, 31),
        isNot(equals(SimpleDate(2021, 02, 01))),
      );
    });

    test('has correct hashcode', () {
      expect(
        SimpleDate(2021, 01, 31).hashCode,
        equals(SimpleDate(2021, 01, 31).hashCode),
      );
    });

    group('.fromDateTime', () {
      test('properly converts DateTime to SimpleDate', () {
        expect(
          SimpleDate.fromDateTime(DateTime(2021, 01, 31)),
          equals(SimpleDate(2021, 01, 31)),
        );
      });
    });

    group('.raw', () {
      test('performs no validation', () {
        const rawInstance = SimpleDate.raw(9999, 99, 99);

        expect(rawInstance.year, equals(9999));
        expect(rawInstance.month, equals(99));
        expect(rawInstance.day, equals(99));
      });
    });

    group('.parse', () {
      test('properly parses String into SimpleDate', () {
        expect(
          SimpleDate.parse('2021-01-31'),
          equals(SimpleDate(2021, 01, 31)),
        );
      });
    });

    test(
      'rolls over to next date when a non-existent date is provided',
      () {
        expect(
          SimpleDate(2021, 01, 32),
          equals(SimpleDate(2021, 02, 01)),
        );
      },
    );

    test(
      'rolls over to previous date when a non-existent date is provided',
      () {
        expect(
          SimpleDate(2021, 02, 0),
          equals(SimpleDate(2021, 01, 31)),
        );
      },
    );

    test('today() is correct', () {
      final now = DateTime.now();
      expect(
        SimpleDate.today(),
        equals(SimpleDate(now.year, now.month, now.day)),
      );
    });

    test('toDateTime converts instance to a DateTime properly', () {
      expect(
        SimpleDate(2021, 01, 31).toDateTime(),
        equals(DateTime(2021, 01, 31)),
      );
    });

    test('isBefore returns true when a date is before another', () {
      expect(
        SimpleDate(2021, 02, 01).isBefore(SimpleDate(2021, 01, 31)),
        isFalse,
      );
      expect(
        SimpleDate(2021, 01, 31).isBefore(SimpleDate(2021, 01, 31)),
        isFalse,
      );

      expect(
        SimpleDate(2021, 01, 31).isBefore(SimpleDate(2021, 02, 01)),
        isTrue,
      );
    });

    test('isAfter returns true when a date is after another', () {
      expect(
        SimpleDate(2021, 01, 31).isAfter(SimpleDate(2021, 02, 01)),
        isFalse,
      );
      expect(
        SimpleDate(2021, 02, 01).isAfter(SimpleDate(2021, 02, 01)),
        isFalse,
      );

      expect(
        SimpleDate(2021, 02, 01).isAfter(SimpleDate(2021, 01, 31)),
        isTrue,
      );
    });

    test('difference returns difference between two dates', () {
      expect(
        SimpleDate(2021, 02, 01).difference(SimpleDate(2021, 01, 31)),
        equals(const Duration(days: 1)),
      );
    });

    group('subtract', () {
      test('subtracts years from date', () {
        expect(
          SimpleDate(2021, 01, 31).subtract(years: 1),
          equals(SimpleDate(2020, 01, 31)),
        );
      });

      test('subtracts months from date', () {
        expect(
          SimpleDate(2021, 02, 01).subtract(months: 1),
          equals(SimpleDate(2021, 01, 01)),
        );
      });

      test('subtracts days from date', () {
        expect(
          SimpleDate(2021, 01, 31).subtract(days: 1),
          equals(SimpleDate(2021, 01, 30)),
        );
      });
    });

    group('add', () {
      test('adds years to date', () {
        expect(
          SimpleDate(2021, 01, 31).add(years: 1),
          equals(SimpleDate(2022, 01, 31)),
        );
      });

      test('adds months to date', () {
        expect(
          SimpleDate(2021, 01, 01).add(months: 1),
          equals(SimpleDate(2021, 02, 01)),
        );
      });

      test('adds days to date', () {
        expect(
          SimpleDate(2021, 01, 30).add(days: 1),
          equals(SimpleDate(2021, 01, 31)),
        );
      });
    });

    group('copyWith', () {
      test('only replaces year field when provided', () {
        const before = 2021;
        const after = 2021;

        final original = SimpleDate(before, 01, 01);
        final copied = original.copyWith(year: after);
        final expected = SimpleDate(after, 01, 01);

        expect(copied, equals(expected));
      });

      test('only replaces month field when provided', () {
        const before = 01;
        const after = 02;

        final original = SimpleDate(2021, before, 01);
        final copied = original.copyWith(month: after);
        final expected = SimpleDate(2021, after, 01);

        expect(copied, equals(expected));
      });

      test('only replaces day field when provided', () {
        const before = 01;
        const after = 02;

        final original = SimpleDate(2021, 01, before);
        final copied = original.copyWith(day: after);
        final expected = SimpleDate(2021, 01, after);

        expect(copied, equals(expected));
      });
    });

    test('toString returns date in correct format', () {
      expect(
        SimpleDate(2021, 01, 31).toString(),
        equals('2021-01-31'),
      );
    });

    test('firstDayOfMonth returns first date of month', () {
      expect(
        SimpleDate(2021, 01, 31).firstDayOfMonth,
        equals(SimpleDate(2021, 01, 01)),
      );
    });

    test('lastDayOfMonth returns last date of month', () {
      expect(
        SimpleDate(2021, 01, 01).lastDayOfMonth,
        equals(SimpleDate(2021, 01, 31)),
      );
    });

    test('weekday returns weekday index', () {
      expect(
        SimpleDate(2021, 01, 01).weekday,
        equals(DateTime.friday),
      );
    });

    test('isWorkingDay returns true when a date falls on a working day', () {
      expect(
        SimpleDate(2021, 01, 01).isWorkingDay,
        isTrue,
      );
      expect(
        SimpleDate(2021, 01, 02).isWorkingDay,
        isFalse,
      );
    });

    test('isWeekendDay returns true when a date falls on a weekend day', () {
      expect(
        SimpleDate(2021, 01, 01).isWeekendDay,
        isFalse,
      );
      expect(
        SimpleDate(2021, 01, 02).isWeekendDay,
        isTrue,
      );
    });

    test('daysInMonth returns the number of days in the month of the date', () {
      expect(
        SimpleDate(2021, 01, 31).daysInMonth,
        equals(31),
      );
    });

    test(
      'workingDaysInMonth returns the number of working days '
      'in the month of the date',
      () {
        expect(
          SimpleDate(2021, 01, 31).workingDaysInMonth,
          equals(21),
        );
      },
    );

    test(
      'workingDaysPassed returns the number of working days '
      'that have passed including the date itself',
      () {
        expect(
          SimpleDate(2021, 01, 15).workingDaysPassed,
          equals(11),
        );
      },
    );

    test(
      'workingDaysRemaining returns the number of working days '
      'that are remaining excluding the date itself',
      () {
        expect(
          SimpleDate(2021, 01, 15).workingDaysRemaining,
          equals(10),
        );
      },
    );
  });
}
