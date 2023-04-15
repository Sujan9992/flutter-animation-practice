import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Animations',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const AnimatedCube(),
      );
}

class AnimatedCube extends StatefulWidget {
  const AnimatedCube({super.key});

  @override
  State<AnimatedCube> createState() => _AnimatedCubeState();
}

class _AnimatedCubeState extends State<AnimatedCube>
    with TickerProviderStateMixin {
  late AnimationController _xController;
  late AnimationController _yController;
  late AnimationController _zController;

  late Tween<double> _xAnimation;

  @override
  void initState() {
    super.initState();
    _xController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _yController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _zController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );

    _xAnimation = Tween<double>(begin: 0, end: pi * 2);
  }

  @override
  void dispose() {
    super.dispose();
    _xController.dispose();
    _yController.dispose();
    _zController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _xController
      ..reset()
      ..repeat();

    _yController
      ..reset()
      ..repeat();

    _zController
      ..reset()
      ..repeat();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: 250,
            width: 250,
            child: AnimatedBuilder(
              animation: Listenable.merge(
                [_xController, _yController, _zController],
              ),
              builder: (context, child) => Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateX(_xAnimation.evaluate(_xController))
                  ..rotateY(_xAnimation.evaluate(_yController))
                  ..rotateZ(_xAnimation.evaluate(_zController)),
                child: Stack(
                  children: [
                    // back
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..translate(
                          Vector3(0, 0, -100),
                        ),
                      child: Container(
                        height: 100,
                        width: 100,
                        color: Colors.blue,
                      ),
                    ),
                    // left
                    Transform(
                      alignment: Alignment.centerLeft,
                      transform: Matrix4.identity()..rotateY(pi / 2),
                      child: Container(
                        height: 100,
                        width: 100,
                        color: Colors.green,
                      ),
                    ),
                    // right
                    Transform(
                      alignment: Alignment.centerRight,
                      transform: Matrix4.identity()..rotateY(-pi / 2),
                      child: Container(
                        height: 100,
                        width: 100,
                        color: Colors.purple,
                      ),
                    ),
                    // front
                    Container(
                      height: 100,
                      width: 100,
                      color: Colors.red,
                    ),
                    // top
                    Transform(
                      alignment: Alignment.topCenter,
                      transform: Matrix4.identity()..rotateX(-pi / 2),
                      child: Container(
                        height: 100,
                        width: 100,
                        color: Colors.yellow,
                      ),
                    ),
                    // bottom
                    Transform(
                      alignment: Alignment.bottomCenter,
                      transform: Matrix4.identity()..rotateX(pi / 2),
                      child: Container(
                        height: 100,
                        width: 100,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
