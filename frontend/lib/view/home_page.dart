import 'package:flutter/material.dart';
import 'package:frontend/utils/spacing_utils.dart';
import 'package:frontend/view/account_page.dart';
import 'package:frontend/view/admin_activity_page.dart';
import 'package:frontend/view/admin_student_information.dart';
import 'package:frontend/view/archive_page.dart';
import 'package:frontend/view/calendar_page.dart';
import 'package:frontend/view/create_activity_page.dart';
import 'package:frontend/view/dashboard_page.dart';
import 'package:frontend/viewmodel/dashboard_view_model.dart';
import 'package:frontend/widgets/menu_items_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> user;

  const HomePage({
    super.key,
    required this.user
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // 2. Now you can safely access 'widget'
    _pages = [
      DashboardPage(user: widget.user),
      const CalendarPage(),
      const AccountPage(),
      ArchivePage(user: widget.user,),
      CreateActivityPage(user: widget.user),
      AdminActivityPage(),
      AdminStudentInformation(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DashboardViewModel>();

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.track_changes,
                      color: const Color.fromARGB(255, 41, 37, 37),
                    ),
                    title: Text(
                      "MANAGEMENT TRACKER",
                      style: TextStyle(letterSpacing: 1.5),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                Divider(
                  indent: 20,
                  endIndent: 20,
                  thickness: 1,
                  color: const Color.fromARGB(255, 41, 37, 37),
                ),

                SizedBox(height: 20),

                Expanded(
                  child: Column(
                    children: [
                      MenuItemsWidget(
                        icon: Icons.home,
                        text: "Dashoard",
                        pressed: () => {viewModel.updatePage(0)},
                      ),

                      MenuItemsWidget(
                        icon: Icons.calendar_month,
                        text: "Calendar",
                        pressed: () => {viewModel.updatePage(1)},
                      ),

                      MenuItemsWidget(
                        icon: Icons.archive,
                        text: "Archive",
                        pressed: () => {viewModel.updatePage(3)},
                      ),

                      MenuItemsWidget(
                        icon: Icons.add_circle_outline,
                        text: "Create Activity",
                        pressed: () => {viewModel.updatePage(4)},
                      ),

                      MenuItemsWidget(
                        icon: Icons.add_circle_outline,
                        text: "Activity Approval",
                        pressed: () => {viewModel.updatePage(5)},
                      ),
                      MenuItemsWidget(
                        icon: Icons.add_circle_outline,
                        text: "Student Information",
                        pressed: () => {viewModel.updatePage(6)},
                      ),

                      const Spacer(),

                      Padding(
                        padding: EdgeInsets.only(
                          bottom: SpacingUtils.heightSpacing(context, 0.024),
                        ),
                        child: MenuItemsWidget(
                          icon: Icons.account_circle,
                          text: "Account",
                          pressed: () => {viewModel.updatePage(2)},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color.fromARGB(255, 250, 250, 250),
              child: Center(child: _pages[viewModel.index]),
            ),
          ),
        ],
      ),
    );
  }
}
