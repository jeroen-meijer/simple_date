# Simple Date

A simple date class with no notion of time.

Can be used as a simpler alternative to Dart's DateTime.

## Usage

```dart
final today = SimpleDate.today();
final moonLanding = SimpleDate(1969, 07, 20);

print(today.isAfter(moonLanding)); // true

final birthday = SimpleDate(1998, 07, 20);
final age = birthday.difference(today);
print(age); // My current age!
```

## Features and bugs

Please file feature requests and bugs at the [GitHub repository][repo].

[repo]: https://github.com/jeroen-meijer/simple_date
