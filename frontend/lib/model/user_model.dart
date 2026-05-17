class UserModel {
  final String uid;
  final String username;
  final String email;
  final String role;
  final String department;
  final int cesPoints;
  final List<dynamic> activeParticipatingCesActivities;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.role,
    required this.department,
    required this.cesPoints,
    required this.activeParticipatingCesActivities,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      department: json['department'] ?? '',
      cesPoints: (json['ces_points'] as num?)?.toInt() ?? 0,
      activeParticipatingCesActivities: json['active_participating_ces_activities'] ?? [],
    );
  }
}