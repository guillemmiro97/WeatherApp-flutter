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