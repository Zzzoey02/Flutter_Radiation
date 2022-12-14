import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'station.dart';
import 'stationdata.dart';

IO.Socket socket = IO.io('https://rewes1.glitch.me',
    IO.OptionBuilder().setTransports(['websocket']).build());

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        StationDetail.nameRoute: (context) => const StationDetail(),
      },
      title: 'Radiation monitor',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Station> stations = [];
  List<StationData> stationDataList = [];
  StationData stationTemp = StationData.empty();

  void initState() {
    super.initState();
    connectAndListen();
  }

  void connectAndListen() {
    print('Call func connectAndListen');
    socket.onConnect((_) {
      print('connect');
    });

    socket.on('stations', (data) {
      print('from server $data');
      // '{"name":"Tram2","geolocation":{"latitude":10,"longitude":106},"address":"227-NguyenVanCu","id":"8UKlMQhi9uXujou9AAAs"}';
      List<dynamic> _stations = data;
      setState(() {
        stations =
            _stations.map<Station>((json) => Station.fromJson(json)).toList();
      });
      //remove old station when refresh list station
      List<StationData> _stationDataList = [];
      stations.forEach((e1) {
        var index = stationDataList.indexWhere((e2) => e1.id == e2.id);
        if (index > -1) {
          _stationDataList.add(stationDataList[index]);
        } else {}
      });
      stationDataList = _stationDataList;
    });
    socket.on('temp2app', (data) {
      if (mounted) {
        StationData station_data = StationData.fromJson(data);
        var index = stationDataList
            .indexWhere((element) => station_data.id == element.id);
        if (index > -1) {
          stationDataList[index] = station_data;
        } else {
          stationDataList.add(station_data);
        }
        setState(() {
          stationTemp = station_data;
        });
        print(stationDataList.length);
      }
    });

    //When an event recieved from server, data is added to the stream
    socket.onDisconnect((_) => print('disconnect'));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: ListView.builder(
            itemCount: stations.length,
            itemBuilder: (context, index) {
              return StationItem(
                  item: stations[index],
                  updatedItem: stationTemp,
                  itemList: stationDataList);
            }) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class StationItem extends StatelessWidget {
  const StationItem(
      {Key? key,
      required this.item,
      required this.updatedItem,
      required this.itemList})
      : super(key: key);
  final Station item;
  final StationData updatedItem;
  final List<StationData> itemList;
  @override
  Widget build(BuildContext context) {
    final index = itemList.indexWhere((element) => element.id == item.id);
    final StationData station_data;
    if (index > -1) {
      station_data = updatedItem.id == item.id ? updatedItem : itemList[index];
    } else {
      station_data = StationData.empty();
    }

    return InkWell(
      onTap: () {
        print('Clicked ${item.name}');
        socket.emit('join-room', item.id);
        Navigator.pushNamed(context, StationDetail.nameRoute, arguments: item);
      },
      splashColor: Colors.red,
      child: Card(
        child: Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                item.name,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text('Realtime: ${station_data.realtime}'),
              Text('Temp: ${station_data.tempC}')
            ],
          ),
        ),
      ),
    );
  }
}

class StationDetail extends StatefulWidget {
  const StationDetail({Key? key}) : super(key: key);
  static const nameRoute = '/Detail';
  @override
  _StationDetailState createState() => _StationDetailState();
}

class _StationDetailState extends State<StationDetail> {
  late StationData _stationData;
  bool isLoaded = false;
  void initState() {
    super.initState();
    connectAndListen();
  }

  void connectAndListen() {
    print('Call func connectAndListen in detail');
    socket.onConnect((_) {
      print('connect');
    });
    socket.on('temp2web', (data) {
      print('temp2web from server $data');
      var station = StationData.fromJson(data);
      if (mounted) {
        setState(() {
          isLoaded = true;
          _stationData = station;
        });
      }
      print(_stationData);
    });

    //When an event recieved from server, data is added to the stream
    socket.onDisconnect((_) {
      print('disconnect');
      if (mounted) {
        Navigator.pop(context);
      }
      socket.off('temp2web');
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)!.settings.arguments as Station;
    if (!isLoaded) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return WillPopScope(
          onWillPop: () async {
            print('willPopScope');
            socket.off('temp2web');
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(item.name),
            ),
            body: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date: ${_stationData.date}',
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    //d??? li???u c???a uSv
                    'Address: B???nh Vi???n Ung B?????u-TpHCM',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, //c??ng gi???a
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    //d??? li???u c???a uSv
                    'Temp: ${_stationData.tempC}',
                    style: const TextStyle(color: Colors.orange, fontSize: 30),
                  ),
                  const Text(
                    'oC',
                    style: TextStyle(color: Colors.orange, fontSize: 20),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, //c??ng gi???a
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    //d??? li???u c???a uSv
                    'Humidity: ${_stationData.humi}',
                    style: const TextStyle(color: Colors.orange, fontSize: 30),
                  ),
                  const Text(
                    '%',
                    style: TextStyle(color: Colors.orange, fontSize: 20),
                  ),
                ],
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_stationData.uSv}',
                      style: const TextStyle(color: Colors.red, fontSize: 60),
                    ),
                    const Text(
                      'uSv/h',
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ]),
          ));
    }
  }
}
