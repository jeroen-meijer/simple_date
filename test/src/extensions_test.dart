import 'package:checks/checks.dart';
import 'package:simple_date/simple_date.dart';
import 'package:test/test.dart' hide expect;

void main() {
  group('DateTimeExtensions', () {
    group('toSimpleDate', () {
      test('properly converts DateTime to SimpleDate', () {
        check(DateTime(2021, 01, 31).toSimpleDate())
            .equals(SimpleDate(2021, 01, 31));
      });
    });
  });
}
