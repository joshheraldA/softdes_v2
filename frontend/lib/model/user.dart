class User {
  final String username;
  final String department;
  final String email;
  final String role;
  final String uid;
  final int cesPoints;

  // 1. Change this from List<int> to List<String>
  final List<String> cesParticipating;

  const User({
    required this.username,
    required this.department,
    required this.role,
    required this.cesPoints,
    required this.cesParticipating,
    required this.email,
    required this.uid,
  });

  factory User.fromJson(Map<String, dynamic> jsonData) {
    return User(
      username: jsonData['username'] as String? ?? "",
      email: jsonData['email'] as String? ?? "",
      role: jsonData['role'] as String? ?? "",
      department: jsonData['department'] as String? ?? "Computer Engineering",
      cesPoints: jsonData['ces_points'] as int? ?? 0,
      uid: jsonData['uid'] as String? ?? "",

      // 2. Map the list dynamically and force every item to a String safely
      cesParticipating: jsonData['active_participating_ces_activities'] != null
          ? (jsonData['active_participating_ces_activities'] as List)
                .map((item) => item.toString())
                .toList()
          : [],
    );
  }
}
