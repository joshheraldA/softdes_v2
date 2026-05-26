// test/model/activity_model_test.dart
//
// Tests for the Activity model — fromJson, dateTime parsing, and helpers.
// Run with:  flutter test test/model/activity_model_test.dart
//

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/model/activity.dart';

Map<String, dynamic> _basePayload({
  String month = 'january',
  String day = '15',
  String year = '2026',
  String type = 'Default',
  String isStrenuous = 'false',
  String isOffCampus = 'false',
}) {
  return {
    'uid': 'act_999',
    'title': 'Tree Planting',
    'status': 'active',
    'department': 'BSIT',
    'beneficiaries': 'environment',
    'private': 'false',
    'volunteers': ['vol_1'],
    'facilitator': ['fac_1'],
    'documents': [],
    'date': {'month': month, 'day': day, 'year': year},
    'type': {
      'isStrenuous': isStrenuous,
      'isOffCampus': isOffCampus,
      'type': type,
    },
  };
}

void main() {
  group('Activity.fromJson', () {
    test('parses string fields correctly', () {
      final a = Activity.fromJson(_basePayload());
      expect(a.uid, 'act_999');
      expect(a.title, 'Tree Planting');
      expect(a.status, 'active');
      expect(a.department, 'BSIT');
    });

    test('parses date fields from nested map', () {
      final a = Activity.fromJson(_basePayload(month: 'march', day: '5', year: '2025'));
      expect(a.month, 'march');
      expect(a.day, '5');
      expect(a.year, '2025');
    });

    test('isStrenuous is false when string is "false"', () {
      final a = Activity.fromJson(_basePayload(isStrenuous: 'false'));
      expect(a.isStrenuous, isFalse);
    });

    test('isStrenuous is true when string is "true"', () {
      final a = Activity.fromJson(_basePayload(isStrenuous: 'true'));
      expect(a.isStrenuous, isTrue);
    });

    test('isOffCampus is true when string is "true"', () {
      final a = Activity.fromJson(_basePayload(isOffCampus: 'true'));
      expect(a.isOffCampus, isTrue);
    });

    test('type falls back to Default when missing', () {
      final payload = _basePayload();
      (payload['type'] as Map).remove('type');
      final a = Activity.fromJson(payload);
      expect(a.type, 'Default');
    });

    test('volunteers list is parsed', () {
      final a = Activity.fromJson(_basePayload());
      expect(a.volunteers, ['vol_1']);
    });

    test('null fields fall back gracefully', () {
      final a = Activity.fromJson({});
      expect(a.uid, '');
      expect(a.title, '');
      expect(a.volunteers, isEmpty);
      expect(a.facilitator, isEmpty);
    });
  });

  group('Activity.dateTime', () {
    test('returns correct DateTime for known month', () {
      final a = Activity.fromJson(_basePayload(month: 'february', day: '28', year: '2026'));
      expect(a.dateTime, DateTime(2026, 2, 28));
    });

    test('returns null when day is not a number', () {
      final a = Activity.fromJson(_basePayload(day: 'fifth'));
      expect(a.dateTime, isNull);
    });

    test('returns null when year is blank', () {
      final a = Activity.fromJson(_basePayload(year: ''));
      expect(a.dateTime, isNull);
    });

    test('returns null when month is unrecognised', () {
      final a = Activity.fromJson(_basePayload(month: 'notamonth'));
      expect(a.dateTime, isNull);
    });

    test('month matching is case-insensitive', () {
      // backend stores lowercase; this documents expected behaviour
      final a = Activity.fromJson(_basePayload(month: 'january'));
      expect(a.dateTime?.month, 1);
    });

    test('all twelve months parse to the right number', () {
      const months = [
        ('january', 1), ('february', 2), ('march', 3), ('april', 4),
        ('may', 5), ('june', 6), ('july', 7), ('august', 8),
        ('september', 9), ('october', 10), ('november', 11), ('december', 12),
      ];
      for (final (name, num) in months) {
        final a = Activity.fromJson(_basePayload(month: name, day: '1', year: '2026'));
        expect(a.dateTime?.month, num, reason: '$name should be month $num');
      }
    });
  });

  group('Activity.isActiveOn', () {
    test('returns true on the exact same date', () {
      final a = Activity.fromJson(_basePayload(month: 'june', day: '10', year: '2026'));
      expect(a.isActiveOn(DateTime(2026, 6, 10)), isTrue);
    });

    test('returns false on a different date', () {
      final a = Activity.fromJson(_basePayload(month: 'june', day: '10', year: '2026'));
      expect(a.isActiveOn(DateTime(2026, 6, 11)), isFalse);
    });

    test('returns false when dateTime is null', () {
      final a = Activity.fromJson(_basePayload(day: 'bad'));
      expect(a.isActiveOn(DateTime.now()), isFalse);
    });
  });

  group('Activity.hasVolunteer', () {
    test('returns true when uid is in volunteers list', () {
      final payload = _basePayload();
      payload['volunteers'] = ['uid_a', 'uid_b'];
      final a = Activity.fromJson(payload);
      expect(a.hasVolunteer('uid_a'), isTrue);
    });

    test('returns false when uid is not in the list', () {
      final a = Activity.fromJson(_basePayload());
      expect(a.hasVolunteer('random_uid'), isFalse);
    });

    test('returns false on an empty volunteers list', () {
      final payload = _basePayload();
      payload['volunteers'] = [];
      final a = Activity.fromJson(payload);
      expect(a.hasVolunteer('anyone'), isFalse);
    });
  });
}
