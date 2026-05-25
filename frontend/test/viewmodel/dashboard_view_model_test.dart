// test/viewmodel/dashboard_view_model_test.dart
//
// Tests for DashboardViewModel — page index, initial lists, etc.
// Network calls are out of scope here.
//
// Run with:  flutter test test/viewmodel/dashboard_view_model_test.dart
//

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/viewmodel/dashboard_view_model.dart';

void main() {
  late DashboardViewModel vm;

  setUp(() => vm = DashboardViewModel());

  group('DashboardViewModel initial state', () {
    test('selected index starts at 0', () {
      expect(vm.index, 0);
    });

    test('activities participating starts empty', () {
      expect(vm.activitiesParticipating, isEmpty);
    });

    test('boxes starts as empty list', () {
      expect(vm.boxes, isEmpty);
    });

    test('calendarViewModel is null until injected', () {
      expect(vm.calendarViewModel, isNull);
    });
  });

  group('updatePage', () {
    test('changes the selected index', () {
      vm.updatePage(2);
      expect(vm.index, 2);
    });

    test('changing to the same index is a no-op but does not throw', () {
      vm.updatePage(0);
      vm.updatePage(0);
      expect(vm.index, 0);
    });

    test('supports all expected navigation indexes', () {
      for (final i in [0, 1, 2, 3]) {
        vm.updatePage(i);
        expect(vm.index, i);
      }
    });

    test('notifies listeners on index change', () {
      var notified = false;
      vm.addListener(() => notified = true);
      vm.updatePage(1);
      expect(notified, isTrue);
    });
  });
}
