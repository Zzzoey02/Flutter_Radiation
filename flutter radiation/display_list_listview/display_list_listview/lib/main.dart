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
      title: 'Display list by listView',
      home: MyHomePage(),
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});
  // ignore: non_constant_identifier_names
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
    Station(11, 'Tram 11', 'Public', true),
    Station(12, 'Tram 12', 'Public', true),
    Station(13, 'Tram 13', 'Private', false),
    Station(14, 'Tram 14', 'Private', false),
    Station(15, 'Tram 15', 'Private', false),
    Station(16, 'Tram 16', 'Public', true),
    Station(17, 'Tram 17', 'Public', true),
    Station(18, 'Tram 18', 'Private', false),
    Station(19, 'Tram 19', 'Private', false),
    Station(20, 'Tram 20', 'Private', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView.builder(
          itemCount: Stations.length,
          itemBuilder: (context, index) {
            final item = Stations[index];
            return ListTile(
              leading: Icon(
                Icons.online_prediction,
                color: item.status ? Colors.red : Colors.grey,
              ),
              title: Text(
                item.name,
                style: const TextStyle(color: Colors.deepPurple),
              ),
              trailing: Icon(item.type == 'Public' ? Icons.public : Icons.lock),
            );
          }),
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
