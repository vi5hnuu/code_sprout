import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawOnScreen extends StatefulWidget {
  final Color penColor;

  const DrawOnScreen({super.key, this.penColor = Colors.blue});

  @override
  _DrawOnScreenState createState() => _DrawOnScreenState();
}

class _DrawOnScreenState extends State<DrawOnScreen> {
  List<Offset?> _points = [];
  bool isErasing=false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onPanUpdate:(details) {
            if (isErasing) {
              for (int i = 0; i < _points.length; i++) {
                if (_points[i] != null && (_points[i]! - details.localPosition).distance < 20) {
                  _points[i] = null; // Mark this point as erased
                }
              }
            } else {
              _points.add(details.localPosition);
            }
            setState((){});
          },
          onPanEnd: (_) {
            setState(() {
              _points.add(null); // Adds a break in the drawing.
            });
          },
          child: CustomPaint(
            painter: DrawingPainter(_points,paintColor: widget.penColor),
            child: Container(),
          ),
        ),
        Positioned(left: 5,top: 5,child: IconButton(onPressed: () => setState(()=>isErasing=!isErasing), icon: Icon(FontAwesomeIcons.eraser,color: Colors.white,),style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(isErasing ? Colors.green : Colors.grey)),)),
      ],
    );
  }
}

class DrawingPainter extends CustomPainter {
  final Color paintColor;
  final List<Offset?> points;

  DrawingPainter(this.points, {this.paintColor = Colors.blue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = paintColor
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
