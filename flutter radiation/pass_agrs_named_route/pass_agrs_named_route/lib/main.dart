import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        DetailScreen.NameRoute: (context) => const DetailScreen(),
      },
      title: 'Flutter Demo',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, DetailScreen.NameRoute,
                      arguments: ArgumentScreen("tittle 1", "content 1"));
                },
                child: const Text('Item 1')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, DetailScreen.NameRoute,
                      arguments: ArgumentScreen("tittle 2", "content 2"));
                },
                child: const Text('Item 2'))
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});
  static const NameRoute = '/Detail';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ArgumentScreen;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.tittle),
      ),
      body: Center(
        child: Text(args.content),
      ),
    );
  }
}

class ArgumentScreen {
  String tittle;
  String content;
  ArgumentScreen(this.tittle, this.content);
}
