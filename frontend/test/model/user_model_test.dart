// test/model/user_model_test.dart
//
// Tests for UserModel deserialization.
// Run with:  flutter test test/model/user_model_test.dart
//

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/model/user_model.dart';

void main() {
  group('UserModel.fromJson', () {
    test('parses a complete, well-formed payload', () {
      final json = {
        'uid': 'abc123',
        'username': 'juandelacruz',
        'email': 'juan@usc.edu.ph',
        'role': 'student',
        'department': 'BSCS',
        'ces_points': 15,
        'active_participating_ces_activities': ['act_1', 'act_2'],
      };

      final user = UserModel.fromJson(json);

      expect(user.uid, 'abc123');
      expect(user.username, 'juandelacruz');
      expect(user.email, 'juan@usc.edu.ph');
      expect(user.role, 'student');
      expect(user.department, 'BSCS');
      expect(user.cesPoints, 15);
      expect(user.activeParticipatingCesActivities, ['act_1', 'act_2']);
    });

    test('falls back to empty strings when fields are missing', () {
      final user = UserModel.fromJson({});

      expect(user.uid, '');
      expect(user.username, '');
      expect(user.email, '');
      expect(user.role, '');
      expect(user.department, '');
    });

    test('ces_points defaults to 0 when missing', () {
      final user = UserModel.fromJson({'uid': 'x'});
      expect(user.cesPoints, 0);
    });

    test('ces_points cast from double works', () {
      // Firestore sometimes sends numbers as doubles
      final user = UserModel.fromJson({'ces_points': 5.0});
      expect(user.cesPoints, 5);
    });

    test('active activities defaults to empty list when missing', () {
      final user = UserModel.fromJson({});
      expect(user.activeParticipatingCesActivities, isEmpty);
    });

    test('active activities preserves all entries', () {
      final ids = ['a', 'b', 'c', 'd'];
      final user = UserModel.fromJson({'active_participating_ces_activities': ids});
      expect(user.activeParticipatingCesActivities.length, 4);
    });
  });
}
