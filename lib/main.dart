import 'package:flutter/material.dart';
import 'package:weather_app/helpers/weather_api.dart';
import 'package:weather_app/modal/weather.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: buildMaterialColor(Color(0xff2F2E41)),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    ),
  );
}

MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var appColor = const Color(0xff3F3D56);
  var appColor2 = const Color(0xff6C63FF);
  String city = "Surat";

  late Future<Weather?> future;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    future = WeatherAPI.weatherAPI.fetchWeatherAPI(city: city);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: future,
          builder: (context, snapShot) {
            if (snapShot.hasError) {
              return Center(
                child: Text("${snapShot.error}"),
              );
            } else if (snapShot.hasData) {
              Weather? data = snapShot.data as Weather?;

              return Padding(
                padding: const EdgeInsets.all(15),
                child: ListView(
                  children: [
                    TextField(
                      controller: searchController,
                      onSubmitted: (val) {
                        setState(() {
                          city = searchController.text;
                          future =
                              WeatherAPI.weatherAPI.fetchWeatherAPI(city: city);
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Enter City Name",
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: TextButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              city = searchController.text;
                              future = WeatherAPI.weatherAPI
                                  .fetchWeatherAPI(city: city);
                            });
                          },
                          child: const Text("Search"),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 230,
                          child: Image.asset(
                              "assets/images/${(data!.name == "Clouds") ? "cloud" : (data.name == "Rain") ? "rain" : (data.name == "Snow") ? "snow" : (data.name == "Sunny") ? "sun" : "all"}.png"),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: appColor2,
                              size: 30,
                            ),
                            SizedBox(width: 3),
                            Text(
                              city,
                              style: TextStyle(
                                color: appColor,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "${(data.temp - 273.15).toInt()}",
                              style: TextStyle(
                                color: appColor2,
                                fontSize: 60,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "°C",
                                  style: TextStyle(
                                    color: appColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  data.name,
                                  style: TextStyle(
                                    color: appColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            data.description,
                            style: TextStyle(
                              fontSize: 21,
                              color: appColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Divider(color: appColor, endIndent: 20, indent: 20),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.water_drop_outlined,
                                    size: 40,
                                    color: appColor2,
                                  ),
                                  Text(
                                    "${data.humidity}",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.speed_rounded,
                                    size: 40,
                                    color: appColor2,
                                  ),
                                  Text(
                                    "${data.speed}",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.rotate_90_degrees_cw,
                                    size: 37,
                                    color: appColor2,
                                  ),
                                  Text(
                                    "${data.degree}",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Divider(color: appColor, endIndent: 20, indent: 20),
                      ],
                    ),
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
