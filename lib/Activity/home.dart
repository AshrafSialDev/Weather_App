import 'dart:math';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  late String cityHint;

  @override
  void initState() {
    super.initState();
    var cityName = [
      "Karachi", "Lahore", "Islamabad", "Rawalpindi", "Faisalabad", "Multan",
      "Peshawar", "Quetta", "Sialkot", "Gujranwala", "Hyderabad", "Sargodha",
      "Bahawalpur", "Sukkur", "Larkana", "Mardan", "Abbottabad", "Dera Ghazi Khan",
      "Sheikhupura", "Jhang", "Rahim Yar Khan", "Kasur", "Okara", "Wah Cantonment",
      "Nawabshah", "New York", "London", "Tokyo", "Paris", "Dubai", "Singapore",
      "Hong Kong", "Los Angeles", "Sydney", "Toronto", "Berlin", "Madrid", "Rome",
      "Istanbul", "Seoul", "Shanghai", "Beijing", "Bangkok", "Kuala Lumpur",
      "Amsterdam", "Vienna", "Zurich", "Chicago", "San Francisco", "Barcelona",
      "Muzaffargarh",
    ];
    final random = Random();
    cityHint = cityName[random.nextInt(cityName.length)];
    debugPrint("initState");
  }

  @override
  Widget build(BuildContext context) {
    // cityName list moved to initState for efficiency and stability
    
    // Fixed the Map info retrieval to handle null safety
    Map? info = ModalRoute.of(context)?.settings.arguments as Map?;
    String temp = (info?['temp_value'] ?? "0");
    String hum = info?['humidity_value'] ?? "0";
    String air = info?['airSpeed_value'] ?? "0";
    String des = info?['description_value'] ?? "0";
    String loc = info?['location_value'] ?? "Unknown";
    String icon = info?['icon_value'] ?? "Unknown";

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(backgroundColor: Colors.blue[200], elevation: 0),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blue[200]!, Colors.blue[300]!],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  //Search container
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (searchController.text.replaceAll(" ", "") == "") {
                            debugPrint("Blank Search");
                          } else {
                            Navigator.pushReplacementNamed(context, "/loading", arguments: {
                              "searchText" : searchController.text,
                            });
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                          child: const Icon(Icons.search, color: Colors.blue),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onSubmitted: (value) {
                             if (value.replaceAll(" ", "") == "") {
                              debugPrint("Blank Search");
                            } else {
                              Navigator.pushReplacementNamed(context, "/loading", arguments: {
                                "searchText" : value,
                              });
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Search $cityHint",
                            border: InputBorder.none,
                          ),
                          cursorColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Image.network(
                              "https://openweathermap.org/img/wn/$icon@2x.png",
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "$des",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "In $loc",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 2,
                        ),
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(WeatherIcons.day_sunny),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("$temp", style: const TextStyle(fontSize: 60)),
                                const Text("°C", style: TextStyle(fontSize: 30)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                        margin: const EdgeInsets.fromLTRB(20, 5, 10, 0),
                        padding: const EdgeInsets.all(26),
                        height: 200,
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [Icon(WeatherIcons.day_cloudy_windy)],
                            ),
                            const SizedBox(height: 25),
                            Text(
                              air,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text("km/h"),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                        margin: const EdgeInsets.fromLTRB(10, 5, 20, 0),
                        padding: const EdgeInsets.all(26),
                        height: 200,
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [Icon(WeatherIcons.humidity)],
                            ),
                            const SizedBox(height: 25),
                            Text(
                              hum,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text("Percent"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(30),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Developed By Sial.Tech",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Data Provided By OpenWeatherMap.Org",
                        style: TextStyle(fontSize: 10,
                        color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
