import 'package:flutter/material.dart';
import 'package:frontend/utils/spacing_utils.dart';
import 'package:frontend/widgets/indicator.dart';
import 'package:frontend/widgets/action_card.dart';


class NewsCardWidget extends StatefulWidget {
  final String text;

  const NewsCardWidget({
    super.key,
    this.text = ""
  });

  @override
  State<NewsCardWidget> createState() => _NewsCardWidgetState();
}

class _NewsCardWidgetState extends State<NewsCardWidget> {
  @override
  Widget build(BuildContext context) {
    return ActionCard(
      width: MediaQuery.of(context).size.width * 0.35,
      height: MediaQuery.of(context).size.height * 0.12,
      bgColor: const Color.fromARGB(255, 255, 255, 255),
      content: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          children: [
            ProgBarIndicator(
              progress: 100,
              width: MediaQuery.of(context).size.height * 0.09,
              height: MediaQuery.of(context).size.height * 0.09,
            ),
            
            Padding(

              padding: EdgeInsets.only(left: SpacingUtils.widthSpacing(context, 0.05)),
              child: Text(widget.text),
            )
          ],
        ),
      ),
      boxShadows: [
        BoxShadow(
          color: const Color.fromARGB(255, 225, 225, 225).withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
      borderRadiusVal: MediaQuery.of(context).size.height * 0.008,
    );
  }
}
