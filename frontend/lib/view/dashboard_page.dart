import 'package:flutter/material.dart';
import 'package:frontend/utils/size_utils.dart';
import 'package:frontend/viewmodel/dashboard_view_model.dart';
import 'package:frontend/widgets/action_card.dart';
import 'package:frontend/widgets/ces_display_widget.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardViewModel>().getActivities();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DashboardViewModel>();

    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(30, 50, 30, 30),
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ActionCard(
                  width: SizeUtils.width(context, 0.379),
                  height: SizeUtils.height(context, 0.3),
                  content: ListView.builder(
                    itemCount: viewModel.boxes.length,
                    itemBuilder: (context, index) {
                      final activity = viewModel.boxes[index];
                      return CesDisplayWidget(activity: activity);
                    },
                  ),
                  boxShadows: [
                    BoxShadow(
                      color: const Color.fromARGB(170, 200, 200, 200),
                      spreadRadius: 0,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                  borderRadiusVal: 10,
                ),

                ActionCard(
                  width: SizeUtils.width(context, 0.379),
                  height: SizeUtils.height(context, 0.3),
                  content: Text("HLLO"),
                  boxShadows: [
                    BoxShadow(
                      color: const Color.fromARGB(170, 200, 200, 200),
                      spreadRadius: 0,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                  borderRadiusVal: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
