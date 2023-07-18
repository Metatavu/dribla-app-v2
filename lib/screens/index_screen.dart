import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

class IndexScreen extends StatefulWidget {
  const IndexScreen({Key? key}) : super(key: key);

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390,
      height: 844,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0),
        image: DecorationImage(
          image: AssetImage("assets/dribla_background.jpg"),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 189,
            left: 61,
            child: Container(
              width: 273,
              height: 100.76394653320312,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0),
              ),
              child: SvgPicture.asset("assets/dribla_logo.svg"),
            ),
          ),
        ],
      ),
    );
  }
}
