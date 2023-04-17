import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Animations',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const AnimatedContainerAnimation(),
      );
}

class AnimatedContainerAnimation extends StatefulWidget {
  const AnimatedContainerAnimation({super.key});

  @override
  State<AnimatedContainerAnimation> createState() =>
      _AnimatedContainerAnimationState();
}

const defaultWidth = 100.0;

class _AnimatedContainerAnimationState
    extends State<AnimatedContainerAnimation> {
  var _isZoomedIn = false;
  var _buttonText = 'Zoom In';
  var _width = defaultWidth;
  var _curve = Curves.bounceOut;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  width: _width,
                  curve: _curve,
                  duration: const Duration(milliseconds: 350),
                  child: Image.asset('assets/images/image.jpg'),
                ),
              ],
            ),
            TextButton(
              onPressed: () => setState(
                () {
                  _isZoomedIn = !_isZoomedIn;
                  _buttonText = _isZoomedIn ? 'Zoom Out' : 'Zoom In';
                  _width = _isZoomedIn
                      ? MediaQuery.of(context).size.width
                      : defaultWidth;
                  _curve = _isZoomedIn ? Curves.bounceIn : Curves.bounceOut;
                },
              ),
              child: Text(_buttonText),
            ),
          ],
        ),
      );
}
