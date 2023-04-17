import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Animations',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const ColoredTweenCircle(),
      );
}

class CircleClipper extends CustomClipper<Path> {
  const CircleClipper();
  @override
  Path getClip(Size size) {
    var path = Path();
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );
    path.addOval(rect);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Color getRandomColor() => Color(0xFF000000 + Random().nextInt(0x00FFFFFF));

class ColoredTweenCircle extends StatefulWidget {
  const ColoredTweenCircle({super.key});

  @override
  State<ColoredTweenCircle> createState() => _ColoredTweenCircleState();
}

class _ColoredTweenCircleState extends State<ColoredTweenCircle> {
  var color = getRandomColor();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipPath(
          clipper: const CircleClipper(),
          child: TweenAnimationBuilder(
            duration: const Duration(seconds: 1),
            tween: ColorTween(
              begin: getRandomColor(),
              end: color,
            ),
            onEnd: () => setState(() => color = getRandomColor()),
            builder: (BuildContext context, Color? value, Widget? child) =>
                ColorFiltered(
              colorFilter: ColorFilter.mode(color, BlendMode.srcATop),
              child: child!,
            ),
            child: Container(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
