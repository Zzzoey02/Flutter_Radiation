import 'dart:ui';

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
        StationDetail.NameRoute: (context) => const StationDetail(),
      },
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});
  List<Station> Stations = [
    Station(1, 'Tram 1', 'Public', true, 20.1),
    Station(2, 'Tram 2', 'Public', true, 20.2),
    Station(3, 'Tram 3', 'Private', false, 20.3),
    Station(4, 'Tram 4', 'Private', false, 20.4),
    Station(5, 'Tram 5', 'Private', false, 20.5),
    Station(6, 'Tram 6', 'Public', true, 20.6),
    Station(7, 'Tram 7', 'Public', true, 20.7),
    Station(8, 'Tram 8', 'Private', false, 20.8),
    Station(9, 'Tram 9', 'Private', false, 20.9),
    Station(10, 'Tram 10', 'Private', false, 21.0),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: GridView.count(
            childAspectRatio: 1.5,
            crossAxisCount: 2,
            children: Stations.map((item) {
              return StationItem(item: item);
            }).toList()));
  }
}

class StationItem extends StatelessWidget {
  const StationItem({super.key, required this.item});
  final Station item;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() {
        print('Clicked ${item.name}');
        Navigator.pushNamed(context, StationDetail.NameRoute, arguments: item);
      }),
      splashColor: Colors.red,
      child: Card(
        child: Container(
          color: item.status ? Colors.red : Colors.black12,
          alignment: Alignment.center,
          child: Text(
            item.name,
            style: const TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.w200),
          ),
        ),
      ),
    );
  }
}

class StationDetail extends StatelessWidget {
  const StationDetail({super.key});
  static const NameRoute = '/Detail';

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)!.settings.arguments as Station;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: item.status ? Colors.red : Colors.black12,
        title: Text(item.name),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${item.temp}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 25,
              ),
            ),
            Text(
              ' o',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            Text(
              'C',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 25,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Station {
  int id;
  String name;
  String type;
  bool status;
  double temp;
  Station(this.id, this.name, this.type, this.status, this.temp);
}
