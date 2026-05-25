// test/model/day_cell_data_test.dart
//
// Tests for DayCellData computed properties.
// Run with:  flutter test test/model/day_cell_data_test.dart
//

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/model/day_cell_data.dart';
import 'package:frontend/model/activity.dart';

Activity _activity(String type) => Activity(
  uid: 'uid',
  title: 'title',
  status: 'active',
  department: 'CS',
  beneficiaries: 'community',
  private: 'false',
  month: 'january',
  day: '1',
  year: '2026',
  isStrenuous: false,
  isOffCampus: false,
  type: type,
  volunteers: [],
  facilitator: [],
  documents: [],
);

void main() {
  final testDate = DateTime(2026, 1, 1);

  group('DayCellData.isEmpty', () {
    test('is true when no activities', () {
      final cell = DayCellData(date: testDate);
      expect(cell.isEmpty, isTrue);
    });

    test('is false when there is at least one activity', () {
      final cell = DayCellData(date: testDate, activities: [_activity('Default')]);
      expect(cell.isEmpty, isFalse);
    });
  });

  group('DayCellData.isSplit', () {
    test('is false with zero activities', () {
      final cell = DayCellData(date: testDate);
      expect(cell.isSplit, isFalse);
    });

    test('is false with one activity', () {
      final cell = DayCellData(date: testDate, activities: [_activity('Outreach')]);
      expect(cell.isSplit, isFalse);
    });

    test('is false when two activities share the same type', () {
      final cell = DayCellData(
        date: testDate,
        activities: [_activity('Outreach'), _activity('Outreach')],
      );
      expect(cell.isSplit, isFalse);
    });

    test('is true when two activities have different types', () {
      final cell = DayCellData(
        date: testDate,
        activities: [_activity('Outreach'), _activity('Livelihood')],
      );
      expect(cell.isSplit, isTrue);
    });
  });

  group('DayCellData.primaryType', () {
    test('is null when no activities', () {
      final cell = DayCellData(date: testDate);
      expect(cell.primaryType, isNull);
    });

    test('returns first activity type when one exists', () {
      final cell = DayCellData(date: testDate, activities: [_activity('Outreach')]);
      expect(cell.primaryType, 'Outreach');
    });
  });

  group('DayCellData.secondaryType', () {
    test('is null when not a split cell', () {
      final cell = DayCellData(date: testDate, activities: [_activity('Default')]);
      expect(cell.secondaryType, isNull);
    });

    test('returns second activity type on a split cell', () {
      final cell = DayCellData(
        date: testDate,
        activities: [_activity('Outreach'), _activity('Livelihood')],
      );
      expect(cell.secondaryType, 'Livelihood');
    });
  });
}
