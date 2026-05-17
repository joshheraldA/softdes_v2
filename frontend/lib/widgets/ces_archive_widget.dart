import 'package:flutter/material.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/utils/ces_type.dart';
import 'package:frontend/utils/size_utils.dart';
import 'package:frontend/viewmodel/dashboard_view_model.dart';
import 'package:frontend/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class CesArchiveWidget extends StatefulWidget {
  final dynamic infoActivity;
  final User? user; // Added user to get the ID

  const CesArchiveWidget({super.key, required this.infoActivity, this.user});

  @override
  State<CesArchiveWidget> createState() => _CesArchiveWidgetState();
}

class _CesArchiveWidgetState extends State<CesArchiveWidget> {
  @override
  Widget build(BuildContext context) {
    // Safely get design config from the activity type
    final designConfig = CesManager.getType(
      widget.infoActivity['type']['type'],
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 243, 240, 240),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          // Changed from BoxBorder.all
          color: Colors.grey,
          width: 1,
        ),
      ),
      width: SizeUtils.width(context, 0.20),
      height: SizeUtils.height(context, 0.20),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            // Title with constraints to prevent overflow
            Positioned(
              left: 0,
              top: 0,
              right: 100,
              child: Text(
                widget.infoActivity['title'] ?? 'No Title',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            // The Type Badge
            TypeIndicator(color: designConfig.color, type: designConfig.type),

            // Join Button
            Align(
              alignment: Alignment.bottomRight,
              child: RoundedButton(
                backGroundColor: const Color.fromARGB(255, 239, 204, 156),
                width: 50,
                height: 50,
                onPressed: () {
                  // Corresponds to the 3 positional arguments expected:
                  // 1. User ID (from the widget.user map)
                  // 2. Activity ID (from the infoActivity map)
                  // 3. The Activity Data (passing the whole map)
                  context.read<DashboardViewModel>().joinActivity(
                    widget.user!.uid,
                    widget.infoActivity['uid'],
                    widget.user!.cesParticipating,
                  );
                },
                child: const Text("Join"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ========================================================
//                      Indicator Type
// ========================================================
class TypeIndicator extends StatelessWidget {
  final Color color;
  final String type;

  const TypeIndicator({super.key, required this.color, required this.type});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: 90,
        height: 20,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Center(
          child: Text(
            type,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ),
      ),
    );
  }
}
