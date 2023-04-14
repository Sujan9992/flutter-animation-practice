import 'package:flutter/material.dart';
import 'dart:math' show pi;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Animations',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const AnimatedCircle(),
      );
}

enum CircleSide { left, right }

extension ToPath on CircleSide {
  Path toPath(Size size) {
    final path = Path();

    late Offset offset;
    late bool isClockwise;

    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        isClockwise = false;
        break;
      case CircleSide.right:
        offset = Offset(0, size.height);
        isClockwise = true;
        break;
    }
    path.arcToPoint(
      offset,
      radius: Radius.elliptical(size.width / 2, size.height / 2),
      clockwise: isClockwise,
    );
    path.close();
    return path;
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;

  const HalfCircleClipper({required this.side});

  @override
  Path getClip(Size size) => side.toPath(size);

  @override
  // redraw path when change happens to parent
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class AnimatedCircle extends StatefulWidget {
  const AnimatedCircle({super.key});

  @override
  State<AnimatedCircle> createState() => _AnimatedCircleState();
}

extension on VoidCallback {
  Future<void> delayed([Duration duration = const Duration(seconds: 1)]) =>
      Future.delayed(duration, this);
}

class _AnimatedCircleState extends State<AnimatedCircle>
    with TickerProviderStateMixin {
  late AnimationController _counterClockwiseRotationController;
  late Animation<double> _counterClockwiseRotationAnimation;

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _counterClockwiseRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _counterClockwiseRotationAnimation =
        Tween<double>(begin: 0, end: -(pi / 2)).animate(
      CurvedAnimation(
        parent: _counterClockwiseRotationController,
        curve: Curves.bounceOut,
      ),
    );

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.bounceOut,
      ),
    );

    _counterClockwiseRotationController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          _flipAnimation = Tween<double>(
                  begin: _flipAnimation.value, end: _flipAnimation.value + pi)
              .animate(
            CurvedAnimation(
              parent: _flipController,
              curve: Curves.bounceOut,
            ),
          );
          // reset the flip controller and start the animation
          _flipController
            ..reset()
            ..forward();
        }
      },
    );

    _flipController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          _counterClockwiseRotationAnimation = Tween<double>(
            begin: _counterClockwiseRotationAnimation.value,
            end: _counterClockwiseRotationAnimation.value + -(pi / 2),
          ).animate(
            CurvedAnimation(
              parent: _counterClockwiseRotationController,
              curve: Curves.bounceOut,
            ),
          );
          // reset the counter clockwise controller and start the animation
          _counterClockwiseRotationController
            ..reset()
            ..forward();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _counterClockwiseRotationController.dispose();
    _flipController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _counterClockwiseRotationController
      ..reset()
      ..forward.delayed();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _counterClockwiseRotationController,
            builder: (context, child) => Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateZ(_counterClockwiseRotationAnimation.value),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _flipController,
                    builder: (context, child) => Transform(
                      alignment: Alignment.centerRight,
                      transform: Matrix4.identity()
                        ..rotateY(_flipAnimation.value),
                      child: ClipPath(
                        clipper: const HalfCircleClipper(side: CircleSide.left),
                        child: Container(
                          width: 150,
                          height: 150,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _flipAnimation,
                    builder: (context, child) => Transform(
                      alignment: Alignment.centerLeft,
                      transform: Matrix4.identity()
                        ..rotateY(_flipAnimation.value),
                      child: ClipPath(
                        clipper:
                            const HalfCircleClipper(side: CircleSide.right),
                        child: Container(
                          width: 150,
                          height: 150,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
