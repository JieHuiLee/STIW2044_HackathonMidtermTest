import 'dart:async';
import 'package:flutter/material.dart';
import 'mainpage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        color: const Color.fromRGBO(168, 208, 209, 1), //#A8D0D1 (SkyBlue)
        theme: ThemeData(
          backgroundColor:
              const Color.fromRGBO(168, 208, 209, 1), //#A8D0D1 (SkyBlue)
          brightness: Brightness.light,
          fontFamily: 'Georgia',
          textTheme: const TextTheme(
            headline5: TextStyle(fontSize: 20.0),
            bodyText1: TextStyle(
                fontSize: 12.0,
                fontFamily: 'Hind',
                color: Color.fromRGBO(217, 217, 217, 1)),
          ),
        ),
        title: 'RENT A ROOM',
        home: const Scaffold(body: SplashPage()));
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainPage(
                title: 'Rent A Room',
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/rentaroom.png'),
                    fit: BoxFit.cover))),
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 100),
            child: Column(children: const [
              Text(
                "You can afford and enjoy your time.",
                style: TextStyle(
                    fontSize: 10,
                    color: Color.fromRGBO(60, 59, 110, 1),
                    fontWeight: FontWeight.bold),
              ),
              LinearProgressIndicator(),
              Text(
                "\n\nVersion 0.1",
                style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(60, 59, 110, 1),
                    fontWeight: FontWeight.bold),
              ),
            ]))
      ],
    );
  }
}
