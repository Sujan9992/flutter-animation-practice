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
        home: const HomePage(),
      );
}

class AnimatedDrawer extends StatefulWidget {
  const AnimatedDrawer({super.key, required this.child, required this.drawer});
  final Widget child;
  final Widget drawer;

  @override
  State<AnimatedDrawer> createState() => _AnimatedDrawerState();
}

class _AnimatedDrawerState extends State<AnimatedDrawer>
    with TickerProviderStateMixin {
  late AnimationController _xControllerChild;
  late Animation<double> _yRotationAnimationChild;

  late AnimationController _xControllerDrawer;
  late Animation<double> _yRotationAnimationDrawer;

  @override
  void initState() {
    super.initState();

    _xControllerChild = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _yRotationAnimationChild =
        Tween<double>(begin: 0, end: -pi / 2).animate(_xControllerChild);

    _xControllerDrawer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _yRotationAnimationDrawer =
        Tween<double>(begin: pi / 2.7, end: 0).animate(_xControllerDrawer);
  }

  @override
  void dispose() {
    super.dispose();
    _xControllerChild.dispose();
    _xControllerDrawer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxDrag = screenWidth * 0.8;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        _xControllerChild.value += details.delta.dx / maxDrag;
        _xControllerDrawer.value += details.delta.dx / maxDrag;
      },
      onHorizontalDragEnd: (details) {
        if (_xControllerChild.value < 0.5) {
          _xControllerChild.reverse();
          _xControllerDrawer.reverse();
        } else {
          _xControllerChild.forward();
          _xControllerDrawer.forward();
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_xControllerChild, _xControllerDrawer]),
        builder: (BuildContext context, Widget? child) => Stack(
          children: [
            Container(color: Colors.grey),
            Transform(
              alignment: Alignment.centerLeft,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..translate(_xControllerChild.value * maxDrag)
                ..rotateY(_yRotationAnimationChild.value),
              child: widget.child,
            ),
            Transform(
              alignment: Alignment.centerRight,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..translate(-screenWidth + _xControllerDrawer.value * maxDrag)
                ..rotateY(_yRotationAnimationDrawer.value),
              child: widget.drawer,
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => AnimatedDrawer(
        drawer: Material(
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 100, top: 50),
            itemCount: 20,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  'Item $index',
                  style: const TextStyle(color: Colors.blue),
                ),
              );
            },
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Animated Drawer'),
            leading: const Icon(Icons.menu),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text('Animated Drawer'),
              ],
            ),
          ),
        ),
      );
}
