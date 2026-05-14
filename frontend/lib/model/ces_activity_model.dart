class CesActivity {
  final String uid;
  final String title;
  final String department;
  final String approvalStatus;
  final String status;
  final String beneficiaries;
  final List<dynamic> facilitator;
  final Map<String, dynamic> date;
  final Map<String, dynamic> type;

  CesActivity({
    required this.uid,
    required this.title,
    required this.department,
    required this.approvalStatus,
    required this.status,
    required this.beneficiaries,
    required this.facilitator,
    required this.date,
    required this.type,
  });

  factory CesActivity.fromJson(Map<String, dynamic> json) {
    return CesActivity(
      uid: json['uid'],
      title: json['title'],
      department: json['department'],
      approvalStatus: json['approval_status'],
      status: json['status'],
      beneficiaries: json['beneficiaries'],
      facilitator: json['facilitator'],
      date: json['date'],
      type: json['type'],
    );
  }
}