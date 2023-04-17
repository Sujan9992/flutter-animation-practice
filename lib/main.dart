import 'package:flutter/material.dart';
import 'package:flutter_animation_practice/model/person.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Animations',
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
        home: const HeroAnimation(),
      );
}

const people = <Person>[
  Person(name: 'Ram', age: 20, emoji: '🧑'),
  Person(name: 'Sam', age: 23, emoji: '👦'),
];

class HeroAnimation extends StatelessWidget {
  const HeroAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: const Text('Person'),
      ),
      body: ListView.builder(
        itemCount: people.length,
        itemBuilder: (BuildContext context, int index) => ListTile(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => DetailsPage(
                person: people[index],
              ),
            ),
          ),
          leading: Hero(
            tag: people[index].name,
            child: Text(
              people[index].emoji,
              style: const TextStyle(fontSize: 30),
            ),
          ),
          title: Text(
            people[index].name,
            style: const TextStyle(fontSize: 30),
          ),
          subtitle: Text(
            people[index].age.toString(),
            style: const TextStyle(fontSize: 30),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key, required this.person});
  final Person person;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Hero(
          tag: person.name,
          flightShuttleBuilder: (flightContext, animation, flightDirection,
              fromHeroContext, toHeroContext) {
            switch (flightDirection) {
              case HeroFlightDirection.push:
                return Material(
                  color: Colors.transparent,
                  child: ScaleTransition(
                    scale: animation.drive(
                      Tween<double>(begin: 0, end: 1).chain(
                        CurveTween(curve: Curves.fastOutSlowIn),
                      ),
                    ),
                    child: toHeroContext.widget,
                  ),
                );
              case HeroFlightDirection.pop:
                return Material(
                  color: Colors.transparent,
                  child: fromHeroContext.widget,
                );
            }
          },
          child: Text(
            person.emoji,
            style: const TextStyle(fontSize: 30),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              person.name,
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              person.age.toString(),
              style: const TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
