import 'package:flutter/material.dart';

class FirebaseSidebarLayout extends StatefulWidget {
  const FirebaseSidebarLayout({super.key});

  @override
  State<FirebaseSidebarLayout> createState() => _FirebaseSidebarLayoutState();
}

class _FirebaseSidebarLayoutState extends State<FirebaseSidebarLayout> {
  // Tracks which page is currently visible
  int _selectedIndex = 0;

  // The list of different screens in your app
  final List<Widget> _pages = [
    const Center(child: Text('Project Overview Content', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Authentication Settings', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Firestore Database', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Hosting Details', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background for the main body
      body: Row(
        children: [
          // THE SIDEBAR
          Container(
            width: 260,
            color: const Color(0xFF1A1C1E), // Firebase-style dark drawer color
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Branding Header
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Icon(Icons.local_fire_department, color: Colors.orange, size: 30),
                      SizedBox(width: 10),
                      Text(
                        'Firebase',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                // Navigation Items
                Expanded(
                  child: ListView(
                    children: [
                      _buildNavItem(Icons.home_outlined, 'Project Overview', 0),
                      _buildSectionHeader("Project shortcuts"),
                      _buildNavItem(Icons.people_outline, 'Authentication', 1),
                      _buildNavItem(Icons.storage_rounded, 'Firestore', 2),
                      _buildSectionHeader("Build"),
                      _buildNavItem(Icons.cloud_upload_outlined, 'Hosting', 3, isNew: true),
                    ],
                  ),
                ),

                // Bottom Collapse Arrow (as seen in image_5bb43c.jpg)
                const Divider(color: Colors.white12),
                ListTile(
                  leading: const Icon(Icons.arrow_back_ios_new, color: Colors.grey, size: 16),
                  onTap: () {
                    // Logic to collapse drawer could go here
                  },
                ),
              ],
            ),
          ),

          // THE MAIN CONTENT AREA
          Expanded(
            child: Container(
              color: const Color(0xFF0F1011),
              // IndexedStack switches pages while keeping their state alive
              child: IndexedStack(
                index: _selectedIndex,
                children: _pages,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper for Section Titles
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Widget helper for Navigation Buttons
  Widget _buildNavItem(IconData icon, String label, int index, {bool isNew = false}) {
    bool isSelected = _selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withOpacity(0.05) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          color: isSelected ? Colors.blueAccent : Colors.grey[400],
          size: 20,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blueAccent : Colors.white70,
            fontSize: 14,
          ),
        ),
        trailing: isNew
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text("NEW", style: TextStyle(color: Colors.blueAccent, fontSize: 9)),
              )
            : null,
        onTap: () {
          // This updates the UI and switches the page
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}