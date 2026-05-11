/// Mirrors the CESArchive Firestore document returned by the Django API.
/// This is a pure data class — no logic, no Flutter imports.
class Activity {
  final String uid;
  final String title;
  final String status;
  final String department;
  final String beneficiaries;
  final String private;

  final String month; // e.g. "May"
  final String day; // e.g. "24"
  final String year; // e.g. "2006"

  final bool isStrenuous;
  final bool isOffCampus;
  final String type; // e.g. "Outreach"

  final List<String> volunteers;
  final List<String> facilitator;
  final List<dynamic> documents;

  const Activity({
    required this.uid,
    required this.title,
    required this.status,
    required this.department,
    required this.beneficiaries,
    required this.private,
    required this.month,
    required this.day,
    required this.year,
    required this.isStrenuous,
    required this.isOffCampus,
    required this.type,
    required this.volunteers,
    required this.facilitator,
    required this.documents,
  });

  /// Deserializes from the JSON the Django API returns in `get_ces`.
  factory Activity.fromJson(Map<String, dynamic> json) {
    final date = json['date'] as Map<String, dynamic>? ?? {};
    final typeMap = json['type'] as Map<String, dynamic>? ?? {};

    return Activity(
      uid: json['uid'] as String? ?? '',
      title: json['title'] as String? ?? '',
      status: json['status'] as String? ?? '',
      department: json['department'] as String? ?? '',
      beneficiaries: json['beneficiaries'] as String? ?? '',
      private: json['private'] as String? ?? 'false',
      month: date['month'] as String? ?? '',
      day: date['day'] as String? ?? '',
      year: date['year'] as String? ?? '',
      isStrenuous: (typeMap['isStrenuous'] as String?) == 'true',
      isOffCampus: (typeMap['isOffCampus'] as String?) == 'true',
      type: typeMap['type'] as String? ?? '',
      volunteers: List<String>.from(json['volunteers'] as List? ?? []),
      facilitator: List<String>.from(json['facilitator'] as List? ?? []),
      documents: List<dynamic>.from(json['documents'] as List? ?? []),
    );
  }

  /// Converts the stored date strings into a [DateTime] for calendar placement.
  /// Returns null if the date fields are missing or unparseable.
  DateTime? get dateTime {
    try {
      const monthMap = {
        'january': 1,
        'february': 2,
        'march': 3,
        'april': 4,
        'may': 5,
        'june': 6,
        'july': 7,
        'august': 8,
        'september': 9,
        'october': 10,
        'november': 11,
        'december': 12,
      };
      final m = monthMap[month.toLowerCase()];
      final d = int.tryParse(day);
      final y = int.tryParse(year);
      if (m == null || d == null || y == null) return null;
      return DateTime(y, m, d);
    } catch (_) {
      return null;
    }
  }

  bool isActiveOn(DateTime date) {
    final dt = dateTime;
    if (dt == null) return false;
    return dt.year == date.year && dt.month == date.month && dt.day == date.day;
  }

  bool hasVolunteer(String uid) => volunteers.contains(uid);
}
