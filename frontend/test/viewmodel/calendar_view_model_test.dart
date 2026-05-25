// test/viewmodel/calendar_view_model_test.dart
//
// Tests for CalendarViewModel — month navigation, calendar grid generation,
// and cellDataFor key formatting.
//
// HTTP calls are NOT tested here (those belong in integration tests).
// Run with:  flutter test test/viewmodel/calendar_view_model_test.dart
//

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/viewmodel/calendar_view_model.dart';

void main() {
  late CalendarViewModel vm;

  setUp(() {
    vm = CalendarViewModel();
  });

  group('month navigation', () {
    test('goToNextMonth advances by one month', () {
      final before = vm.focusedMonth;
      vm.goToNextMonth();
      final after = vm.focusedMonth;

      expect(after.month, before.month == 12 ? 1 : before.month + 1);
    });

    test('goToPreviousMonth goes back one month', () {
      final before = vm.focusedMonth;
      vm.goToPreviousMonth();
      final after = vm.focusedMonth;

      expect(after.month, before.month == 1 ? 12 : before.month - 1);
    });

    test('going forward twelve times lands on the same month', () {
      final original = vm.focusedMonth.month;
      for (var i = 0; i < 12; i++) vm.goToNextMonth();
      expect(vm.focusedMonth.month, original);
    });

    test('going backward twelve times lands on the same month', () {
      final original = vm.focusedMonth.month;
      for (var i = 0; i < 12; i++) vm.goToPreviousMonth();
      expect(vm.focusedMonth.month, original);
    });

    test('year rolls over when advancing past december', () {
      // wind to december first
      while (vm.focusedMonth.month != 12) vm.goToNextMonth();
      final yearBefore = vm.focusedMonth.year;
      vm.goToNextMonth();
      expect(vm.focusedMonth.year, yearBefore + 1);
      expect(vm.focusedMonth.month, 1);
    });

    test('year rolls back when going before january', () {
      while (vm.focusedMonth.month != 1) vm.goToPreviousMonth();
      final yearBefore = vm.focusedMonth.year;
      vm.goToPreviousMonth();
      expect(vm.focusedMonth.year, yearBefore - 1);
      expect(vm.focusedMonth.month, 12);
    });
  });

  group('monthLabel', () {
    final labelMap = {
      1: 'Jan', 2: 'Feb', 3: 'Mar', 4: 'Apr',
      5: 'May', 6: 'Jun', 7: 'Jul', 8: 'Aug',
      9: 'Sep', 10: 'Oct', 11: 'Nov', 12: 'Dec',
    };

    test('returns the correct 3-letter abbreviation for every month', () {
      // navigate to each month and verify the label
      while (vm.focusedMonth.month != 1) vm.goToPreviousMonth();
      for (var m = 1; m <= 12; m++) {
        expect(vm.monthLabel, labelMap[m], reason: 'Month $m label mismatch');
        vm.goToNextMonth();
      }
    });
  });

  group('calendarDays', () {
    test('always returns a multiple of 7', () {
      expect(vm.calendarDays.length % 7, 0);
    });

    test('contains all days of the focused month', () {
      final month = vm.focusedMonth;
      final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
      final monthDays = vm.calendarDays.where(
        (d) => d.month == month.month && d.year == month.year,
      );
      expect(monthDays.length, daysInMonth);
    });

    test('first day in the grid is always a Sunday (weekday % 7 == 0)', () {
      expect(vm.calendarDays.first.weekday % 7, 0);
    });

    test('last day in the grid is always a Saturday (weekday % 7 == 6)', () {
      expect(vm.calendarDays.last.weekday % 7, 6);
    });
  });

  group('cellDataFor', () {
    test('returns null when calendar is empty', () {
      expect(vm.cellDataFor(DateTime(2026, 1, 15)), isNull);
    });
  });
}
