import 'package:flutter/material.dart';
import 'package:frontend/utils/spacing_utils.dart';
import 'package:frontend/view/calendar_page.dart';
import 'package:frontend/view/dashboard_page.dart';
import 'package:frontend/viewmodel/dashboard_view_model.dart';
import 'package:frontend/widgets/menu_items_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<Widget> _pages = [
    const DashboardPage(),
    const CalendarPage(),
    const Text("Account pages"),
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DashboardViewModel>();

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 242, 241, 243),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.track_changes, color: const Color.fromARGB(255, 41, 37, 37),),
                  title: Text("MANAGEMENT TRACKER"),
              
                ),

                SizedBox(
                  height: 30,
                ),

                Expanded(
                  child: Column(
                    children: [
                      MenuItemsWidget(
                        icon: Icons.home, 
                        text: "Dashoard", 
                        pressed: () => {
                          viewModel.updatePage(0)
                        }, 
                      ),

                      MenuItemsWidget(
                        icon: Icons.calendar_month, 
                        text: "Calendar", 
                        pressed: () => {
                          viewModel.updatePage(1)
                        }, 
                      ),

                      const Spacer(),

                      Padding(
                        padding: EdgeInsets.only(bottom: SpacingUtils.heightSpacing(context, 0.024)),
                        child: MenuItemsWidget(
                          icon: Icons.account_circle, 
                          text: "Account", 
                          pressed: () => {
                            viewModel.updatePage(2)
                          }, 
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
           
          Expanded(
            child: Center(
              child: _pages[viewModel.index]
            ),
          )
        ],
      )
    );  
  }
}

