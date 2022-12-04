class Weatherdata {
  final String main;
  final String description;
  final String temp;
  final String tempMax;
  final String tempMin;

  const Weatherdata(
      {required this.main,
      required this.description,
      required this.temp,
      required this.tempMax,
      required this.tempMin});

  factory Weatherdata.fromJson(Map<String, dynamic> json) {
    return Weatherdata(
      main: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      temp: json['main']['temp'].toString(),
      tempMax: json['main']['temp_max'].toString(),
      tempMin: json['main']['temp_min'].toString(),
    );
  }
}

class ForecastData {
  final String main;
  final String date;
  final String weatherDescription;
  final String temp;
  final String tempMax;
  final String tempMin;

  const ForecastData(
      {required this.main,
        required this.date,
        required this.weatherDescription,
        required this.temp,
        required this.tempMax,
        required this.tempMin});

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    return ForecastData(
      main: json['weather'][0]['main'],
      date: json['list']['dt_txt'] as String,
      weatherDescription: json['list']['weather']['description'] as String,
      temp: json['list']['main']['temp'].toString(),
      tempMax: json['list']['main']['temp_max'].toString(),
      tempMin: json['list']['main']['temp_min'].toString(),
    );
  }
}