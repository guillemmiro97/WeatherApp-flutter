import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_icons/weather_icons.dart';
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

Future<List<ForecastData>> fetchForecast() async {
  final response = await http
      .get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?'
      'units=metric&appid=f07cca337c89d967b5f2b8dee2884830&q=Barcelona'));

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    List<ForecastData> forecastData = [];
    for (var u in jsonResponse['list']) {
      ForecastData data = ForecastData(
          main: u['weather'][0]['main'],
          date: u['dt_txt'],
          weatherDescription: u['weather'][0]['description'].toString(),
          temp: u['main']['temp'].toString(),
          tempMax: u['main']['temp_max'].toString(),
          tempMin: u['main']['temp_min'].toString());
      forecastData.add(data);
    }

    return forecastData;
  } else {
    throw Exception('Failed to load weather data');
  }
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Weatherdata> weatherData;
  late Future<List<ForecastData>> forecastData;

  @override
  void initState() {
    super.initState();
    weatherData = fetchWeatherData();
    forecastData = fetchForecast();
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
                  FutureBuilder<Weatherdata>(
                    future: weatherData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            const Text(
                              "Barcelona",
                              style:
                                  TextStyle(fontSize: 40, color: Colors.white),
                            ),
                            Text(
                              "${snapshot.data!.temp.split(".")[0]}°",
                              style: const TextStyle(
                                  fontSize: 80, color: Colors.white),
                            ),
                            Text(
                              snapshot.data!.main,
                              style: const TextStyle(
                                  fontSize: 40, color: Colors.white),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Min: ${snapshot.data!.tempMin}°C ",
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                Text(
                                  "Max: ${snapshot.data!.tempMax}°C",
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      // By default, show a loading spinner.
                      return const CircularProgressIndicator();
                    },
                  ),
                ],
              ),
            ),
            Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height,
                ),
                color: Colors.black,
                //send the forecast data to the listview
                child: ListViewBuilder(forecastData: forecastData)),
          ],
        ),
      ),
    );
  }
}

class ListViewBuilder extends StatelessWidget {
  const ListViewBuilder({Key? key, required Future<List<ForecastData>> forecastData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ForecastData>>(
      future: fetchForecast(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Text(
                  "Day ${snapshot.data![index].date.substring(8, 13)}h",
                    style: const TextStyle(fontSize: 20, color: Colors.white)
                ),
                title: getIcon(snapshot.data![index].main),
                trailing: (Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("${snapshot.data!.elementAt(index).temp} ",
                        style: const TextStyle(fontSize: 20, color: Colors.blue)),
                    Text(snapshot.data!.elementAt(index).tempMax,
                        style: const TextStyle(fontSize: 20, color: Colors.red)),
                  ],
                )),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                color: Colors.white,
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }

  //function to get the icon
  Icon getIcon(String main) {
    switch (main) {
      case "Clouds":
        return const Icon(
          WeatherIcons.cloudy,
          color: Colors.white,
        );
      case "Clear":
        return const Icon(
          WeatherIcons.day_sunny,
          color: Colors.white,
        );
      case "Rain":
        return const Icon(
          WeatherIcons.rain,
          color: Colors.white,
        );
      default:
        return const Icon(
          WeatherIcons.snow,
          color: Colors.white,
        );
    }
  }
}