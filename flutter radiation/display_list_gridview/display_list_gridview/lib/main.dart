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
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});
  List<Station> Stations = [
    Station(1, 'Tram 1', 'Public', true),
    Station(2, 'Tram 2', 'Public', true),
    Station(3, 'Tram 3', 'Private', false),
    Station(4, 'Tram 4', 'Private', false),
    Station(5, 'Tram 5', 'Private', false),
    Station(6, 'Tram 6', 'Public', true),
    Station(7, 'Tram 7', 'Public', true),
    Station(8, 'Tram 8', 'Private', false),
    Station(9, 'Tram 9', 'Private', false),
    Station(10, 'Tram 10', 'Private', false),
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

class Station {
  int id;
  String name;
  String type;
  bool status;
  Station(this.id, this.name, this.type, this.status);
}
