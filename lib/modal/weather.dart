class Weather {
  final String name;
  final String description;
  final num temp;
  final num humidity;
  final num speed;
  final num degree;

  Weather({
    required this.name,
    required this.description,
    required this.temp,
    required this.humidity,
    required this.speed,
    required this.degree,
  });

  factory Weather.fromJSON({required Map<String, dynamic> json}) {
    return Weather(
      name: json["weather"][0]["main"],
      description: json["weather"][0]["description"],
      temp: json["main"]["temp"],
      humidity: json["main"]["humidity"],
      speed: json["wind"]["speed"],
      degree: json["wind"]["deg"],
    );
  }
}
