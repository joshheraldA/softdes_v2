import 'package:flutter/material.dart';
import 'package:frontend/viewmodel/registration_view_model.dart';
import 'package:provider/provider.dart';

class CourseSelectionPage extends StatefulWidget {
  final String username;
  final String email;
  final String password;

  const CourseSelectionPage({
    super.key,
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  State<CourseSelectionPage> createState() => _CourseSelectionPageState();
}

class _CourseSelectionPageState extends State<CourseSelectionPage> {
  static const _green = Color(0xFF2E7D32);
  static const _orange = Color(0xFFE65100);

  static const List<Map<String, dynamic>> _courses = [
    {'label': 'Computer Engineering', 'icon': Icons.computer},
    {'label': 'Civil Engineering', 'icon': Icons.foundation},
    {'label': 'Electrical Engineering', 'icon': Icons.bolt},
    {'label': 'Mechanical Engineering', 'icon': Icons.settings},
    {'label': 'Chemical Engineering', 'icon': Icons.science},
    {'label': 'Industrial Engineering', 'icon': Icons.factory},
    {'label': 'Electronics Engineering', 'icon': Icons.memory},
    {'label': 'Geodetic Engineering', 'icon': Icons.map},
    {'label': 'Mining Engineering', 'icon': Icons.terrain},
    {'label': 'Environmental Engineering', 'icon': Icons.eco},
  ];

  String? _selected;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<RegistrationViewModel>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: size.width * 0.42,
            margin: const EdgeInsets.symmetric(vertical: 24),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.school_outlined, size: 48, color: _green),
                const SizedBox(height: 12),
                const Text(
                  'Choose Your Course',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _green,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Select the engineering program you are enrolled in.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.black45),
                ),
                const SizedBox(height: 24),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _courses.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 3.2,
                  ),
                  itemBuilder: (_, i) {
                    final course = _courses[i]['label'] as String;
                    final icon = _courses[i]['icon'] as IconData;
                    final picked = _selected == course;

                    return GestureDetector(
                      onTap: () => setState(() => _selected = course),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        decoration: BoxDecoration(
                          color: picked ? _green : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: picked ? _green : Colors.grey.shade300,
                            width: picked ? 2 : 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              icon,
                              size: 18,
                              color: picked ? Colors.white : _green,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                course,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: picked ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 8),

                // ── Error / status ───────────────────────────────────
                if (vm.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      vm.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),

                const SizedBox(height: 20),

                // ── Confirm button ───────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _selected == null
                        ? null
                        : () async {
                            await vm.updateText(
                              widget.username,
                              widget.email,
                              widget.password,
                              _selected!,
                            );
                            if (vm.text.startsWith('Success') &&
                                context.mounted) {
                              Navigator.popUntil(context, (r) => r.isFirst);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _orange,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Confirm & Create Account',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ── Back button ──────────────────────────────────────
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    '← Go back',
                    style: TextStyle(color: Colors.black38, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
