import 'package:flutter/material.dart';
import 'dart:math';


class ProgBarIndicWidg extends StatefulWidget {
  final double progress;
  final double width;
  final double height;

  const ProgBarIndicWidg({
    super.key,
    required this.progress,
    required this.width,
    required this.height
  });

  @override
  State<ProgBarIndicWidg> createState() => _ProgBarIndicWidgState();
}

class _ProgBarIndicWidgState extends State<ProgBarIndicWidg> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          CustomPaint(
          size: Size(widget.width, widget.height),
          painter: _CurrentProgressBar(progress: widget.progress)
          ),

          CustomPaint(
          size: Size(widget.width, widget.height),
          painter: _RemainingBar(progress: (100 - widget.progress))
          ),
        ]
      
    );
  }
}

class ProgBarIndicator extends StatelessWidget {
  final double progress;
  final double width;
  final double height;
  final double strokeWidth;
  final double offset;

  const ProgBarIndicator({
    super.key,
    required this.progress,
    required this.width,
    required this.height,
    this.strokeWidth = 5,
    this.offset = 4
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          CustomPaint(
          size: Size(width, height),
          painter: _CurrentProgressBar(progress: progress)
          ),
        ]
    );
  }
}

class _CurrentProgressBar extends CustomPainter {
  late double progress;
  final double strokeWidth;

  _CurrentProgressBar({required 
  this.progress,
  // ignore: unused_element_parameter
  this.strokeWidth = 5,

  });

  @override
  void paint(Canvas canvas, Size size) {

    double startPoint = 130 * (pi / 180);

    double endPoint = (280 * ((progress - 2) / 100)) * (pi / 180);
    if(progress == 100) {
      endPoint += (280 * ((2 / 100))) * (pi / 180);
    }
    if(progress == 0) {
      endPoint = 0;
    }
    final center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width / 2) - (strokeWidth / 2) - 4;

    final paint = Paint()
        ..color = Colors.orangeAccent
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startPoint, endPoint, false, paint);

  }

  @override
  bool shouldRepaint(_CurrentProgressBar oldDelegate) =>
    oldDelegate.progress != progress;
}


class _RemainingBar extends CustomPainter {
  late double progress;

  _RemainingBar({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final double strokewidth = 5;

    double startPoint = 50 * (pi / 180);

    double endPoint = - (280 * ((progress - 2) / 100)) * (pi / 180);
    if(progress == 100) {
      endPoint -= (280 * ((2 / 100))) * (pi / 180);
    }
    if(progress == 0) {
      endPoint = 0;
    }
    
    final center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width / 2) - (strokewidth / 2) - 4;

    final paint = Paint()
        ..color = const Color.fromARGB(255, 255, 129, 51)
        ..strokeWidth = strokewidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startPoint, endPoint, false, paint);

  }

  @override
  bool shouldRepaint(_RemainingBar oldDelegate) =>
    oldDelegate.progress != progress;
}

