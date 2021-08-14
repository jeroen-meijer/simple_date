// ignore_for_file: avoid_print
import 'package:simple_date/simple_date.dart';

void main() {
  final today = SimpleDate.today();
  final moonLanding = SimpleDate(1969, 07, 20);

  print(today.isAfter(moonLanding)); // true

  final birthday = SimpleDate(1998, 07, 20);
  final age = birthday.difference(today);
  print(age); // My current age!
}
