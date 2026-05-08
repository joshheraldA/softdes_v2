import 'activity.dart';

/// What one calendar cell needs to render itself.
/// The ViewModel computes this from raw [Activity] data;
/// the View only ever sees this — never the raw list.
class DayCellData {
  final DateTime date;
  final List<Activity> activities; // max 2 (business rule)

  const DayCellData({required this.date, this.activities = const []});

  bool get isEmpty => activities.isEmpty;

  /// True when two activities with different types share the day →
  /// triggers the diagonal-split color render.
  bool get isSplit =>
      activities.length == 2 && activities[0].type != activities[1].type;

  /// The color key for the primary (or only) activity.
  String? get primaryType => activities.isNotEmpty ? activities[0].type : null;

  /// The color key for the secondary activity (split only).
  String? get secondaryType => isSplit ? activities[1].type : null;
}
