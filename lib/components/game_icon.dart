import "dart:async";

import "package:flutter/material.dart";

class GameIcon extends StatefulWidget {
  final List<List<Color>> colorSequency;
  final int animationSpeedMs;
  const GameIcon(
      {super.key, required this.colorSequency, required this.animationSpeedMs});

  @override
  State<StatefulWidget> createState() => _GameIcon();
}

class _GameIcon extends State<GameIcon> {
  List<Color> colors = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.blue,
    Colors.white,
    Colors.white,
    Colors.white
  ];
  int currentAnimationIndex = 0;
  Timer? animationTimer;

  @override
  void initState() {
    colors = widget.colorSequency.first;
    animationTimer = Timer.periodic(
        Duration(milliseconds: widget.animationSpeedMs), (timer) {
      currentAnimationIndex++;
      if (widget.colorSequency.length <= currentAnimationIndex) {
        currentAnimationIndex = 0;
      }
      setState(() {
        colors = widget.colorSequency.elementAt(currentAnimationIndex);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    animationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 200,
      child: AspectRatio(
        aspectRatio: 0.832,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 4.0, color: Colors.white),
              color: const Color.fromARGB(0xff, 0x3f, 0xa5, 0x35)),
          child: Stack(
            children: [
              Positioned(
                  top: 32.0,
                  left: 26.0,
                  child: Circle(color: colors.elementAt(0))),
              Positioned(
                  top: 32.0,
                  left: 116.0,
                  child: Circle(color: colors.elementAt(1))),
              Positioned(
                  top: 58.0,
                  left: 71.0,
                  child: Circle(color: colors.elementAt(2))),
              Positioned(
                  top: 86.0,
                  left: 26.0,
                  child: Circle(color: colors.elementAt(3))),
              Positioned(
                  top: 86.0,
                  left: 116.0,
                  child: Circle(color: colors.elementAt(4))),
              Positioned(
                  top: 113.0,
                  left: 71.0,
                  child: Circle(color: colors.elementAt(5))),
              Positioned(
                  top: 140.0,
                  left: 26.0,
                  child: Circle(color: colors.elementAt(6))),
              Positioned(
                  top: 140.0,
                  left: 116.0,
                  child: Circle(color: colors.elementAt(7))),
            ],
          ),
        ),
      ),
    );
  }
}

class Circle extends StatelessWidget {
  final Color color;

  const Circle({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    double size = 15.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
