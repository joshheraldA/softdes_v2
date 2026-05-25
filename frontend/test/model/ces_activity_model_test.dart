// test/model/ces_activity_model_test.dart
//
// Tests for CesActivity deserialization.
// Run with:  flutter test test/model/ces_activity_model_test.dart
//

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/model/ces_activity_model.dart';

Map<String, dynamic> _basePayload({
  String uid = 'act_001',
  String title = 'Beach Cleanup',
  String approvalStatus = 'pending',
}) {
  return {
    'uid': uid,
    'title': title,
    'department': 'BSCS',
    'approval_status': approvalStatus,
    'status': 'active',
    'beneficiaries': 'Local community',
    'facilitator': ['uid_fac'],
    'date': {'month': 'january', 'day': '15', 'year': '2026'},
    'type': {'isStrenuous': 'false', 'isOffCampus': 'true', 'type': 'Outreach'},
  };
}

void main() {
  group('CesActivity.fromJson', () {
    test('parses all fields correctly', () {
      final activity = CesActivity.fromJson(_basePayload());

      expect(activity.uid, 'act_001');
      expect(activity.title, 'Beach Cleanup');
      expect(activity.department, 'BSCS');
      expect(activity.approvalStatus, 'pending');
      expect(activity.status, 'active');
      expect(activity.beneficiaries, 'Local community');
      expect(activity.facilitator, ['uid_fac']);
    });

    test('date map is preserved as-is', () {
      final activity = CesActivity.fromJson(_basePayload());
      expect(activity.date['month'], 'january');
      expect(activity.date['day'], '15');
      expect(activity.date['year'], '2026');
    });

    test('type map is preserved as-is', () {
      final activity = CesActivity.fromJson(_basePayload());
      expect(activity.type['type'], 'Outreach');
      expect(activity.type['isOffCampus'], 'true');
    });

    test('approval_status approved parses correctly', () {
      final activity = CesActivity.fromJson(
        _basePayload(approvalStatus: 'approved'),
      );
      expect(activity.approvalStatus, 'approved');
    });

    test('approval_status denied parses correctly', () {
      final activity = CesActivity.fromJson(
        _basePayload(approvalStatus: 'denied'),
      );
      expect(activity.approvalStatus, 'denied');
    });

    test('facilitator list with multiple entries is preserved', () {
      final payload = _basePayload();
      payload['facilitator'] = ['uid_1', 'uid_2', 'uid_3'];
      final activity = CesActivity.fromJson(payload);
      expect(activity.facilitator.length, 3);
    });
  });
}
