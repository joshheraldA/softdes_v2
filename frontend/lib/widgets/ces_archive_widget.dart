import 'package:flutter/material.dart';
import 'package:frontend/utils/ces_type.dart';
import 'package:frontend/utils/size_utils.dart';

class CesArchiveWidget extends StatefulWidget {
  final dynamic infoActivity;

  const CesArchiveWidget({
    super.key,
    required this.infoActivity
  });

  @override
  State<CesArchiveWidget> createState() => _CesArchiveWidgetState();
}

class _CesArchiveWidgetState extends State<CesArchiveWidget> {

  @override
  Widget build(BuildContext context) {
    final designConfig = CesManager.getType(widget.infoActivity['type']['type']);

    return Container( 
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 243, 240, 240),
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      width: SizeUtils.width(context, 0.20),
      height: SizeUtils.height(context, 0.20),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack( 
          children: [
            Text(
              widget.infoActivity['title']
            ),

            Align( 
              alignment: Alignment.topRight,
              child: Container(
                width: 30,
                height: 40,
                color: designConfig.color
              )
            )
          ],
        ),
      )
    );  
  }
}