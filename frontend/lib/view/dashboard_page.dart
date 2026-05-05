import 'package:flutter/material.dart';
import 'package:frontend/utils/size_utils.dart';
import 'package:frontend/utils/spacing_utils.dart';
import 'package:frontend/viewmodel/dashboard_view_model.dart';
import 'package:frontend/widgets/action_card.dart';
import 'package:frontend/widgets/ces_display_widget.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const DashboardPage({
    super.key,
    required this.user
  });

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
                  content: Column(
                    children: [
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 245, 245, 245),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                        ),
                        child: Row(children: [
                          SizedBox(width: SpacingUtils.widthSpacing(context, 0.027)),
                          Text("Title", style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(width: SpacingUtils.widthSpacing(context, 0.105)),
                          Text("Type", style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(width: SpacingUtils.widthSpacing(context, 0.065),),
                          Text("Volunteers", style: TextStyle(fontWeight: FontWeight.bold),)
                        ],)
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: viewModel.boxes.length,
                          itemBuilder: (context, index) {
                            final activity = viewModel.boxes[index];
                            return Padding(
                              padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
                              child: CesDisplayWidget(activity: activity, user: widget.user,),
                            );
                          },
                        ),
                      ),
                    ],
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
                  content: Text("${widget.user['username']}"),
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
