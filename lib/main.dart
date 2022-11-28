import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp_flutter/weather.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<Weatherdata> fetchWeatherData() async {
  final response = await http
      .get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?'
          'units=metric&appid=f07cca337c89d967b5f2b8dee2884830&q=Barcelona'));

  if (response.statusCode == 200) {
    return Weatherdata.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load weather data');
  }
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Weatherdata> weatherData;

  @override
  void initState() {
    super.initState();
    weatherData = fetchWeatherData();
    
    print(weatherData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
              ),
              height: 300,
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Barcelona",
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  const Text(
                    "14°C",
                    style: TextStyle(fontSize: 70, color: Colors.white),
                  ),
                  const Text("Despejado",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Min ",
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                      Text("Max",
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height,
                ),
                color: Colors.black,
                child: const ListViewBuilder())
          ],
        ),
      ),
    );
  }
}

class ListViewBuilder extends StatelessWidget {
  const ListViewBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.separated(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Text(
              "List item $index",
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            title: const Icon(
              Icons.sunny,
              color: Colors.white,
            ),
            trailing: (Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text("Min ",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                Text("Max",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ],
            )),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            color: Colors.white,
          );
        },
      ),
    );
  }
}
