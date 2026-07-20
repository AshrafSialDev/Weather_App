import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/worker/worker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  late String cityHint;
  String? temp, hum, air, des, loc, icon, main, city, feelsLike, tempMin, tempMax;
  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _topAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: AlignmentTween(begin: Alignment.topLeft, end: Alignment.topRight),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(begin: Alignment.topRight, end: Alignment.bottomRight),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(begin: Alignment.bottomLeft, end: Alignment.topLeft),
        weight: 1,
      ),
    ]).animate(_controller);

    _bottomAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: AlignmentTween(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(begin: Alignment.bottomLeft, end: Alignment.topLeft),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(begin: Alignment.topLeft, end: Alignment.topRight),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(begin: Alignment.topRight, end: Alignment.bottomRight),
        weight: 1,
      ),
    ]).animate(_controller);

    var cityName = [
      "Karachi", "Lahore", "Islamabad", "Rawalpindi", "Faisalabad", "Multan",
      "Peshawar", "Quetta", "Sialkot", "Gujranwala", "Hyderabad", "Sargodha",
      "Bahawalpur", "Sukkur", "Larkana", "Mardan", "Abbottabad", "Dera Ghazi Khan",
      "Sheikhupura", "Jhang", "Rahim Yar Khan", "Kasur", "Okara", "Wah Cantonment",
      "Nawabshah", "New York", "London", "Tokyo", "Paris", "Dubai", "Singapore",
      "Hong Kong", "Los Angeles", "Sydney", "Toronto", "Berlin", "Madrid", "Rome",
      "Istanbul", "Seoul", "Shanghai", "Beijing", "Bangkok", "Kuala Lumpur",
      "Amsterdam", "Vienna", "Zurich", "Chicago", "San Francisco", "Barcelona",
      "Muzaffargarh", "Sheikhupura",
    ];
    final random = Random();
    cityHint = cityName[random.nextInt(cityName.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (temp == null) {
      Map? info = ModalRoute.of(context)?.settings.arguments as Map?;
      if (info != null) {
        temp = info['temp_value'];
        hum = info['humidity_value'];
        air = info['airSpeed_value'];
        des = info['description_value'];
        loc = info['location_value'];
        icon = info['icon_value'];
        main = info['main_value'];
        city = info['city_value'];
        feelsLike = info['feels_like_value'];
        tempMin = info['temp_min_value'];
        tempMax = info['temp_max_value'];
      }
    }
  }

  Future<void> _refreshData() async {
    if (city == null) return;
    Worker instance = Worker(location: city!);
    await instance.getData();
    if (!mounted) return;
    setState(() {
      temp = instance.temp;
      hum = instance.humidity;
      air = instance.airSpeed;
      des = instance.description;
      main = instance.main;
      loc = instance.location;
      icon = instance.icon;
      feelsLike = instance.feelsLike;
      tempMin = instance.tempMin;
      tempMax = instance.tempMax;
    });
  }

  @override
  Widget build(BuildContext context) {
    // cityName list moved to initState for efficiency and stability

    String displayTemp = temp ?? "0";
    String displayHum = hum ?? "0";
    String displayAir = air ?? "0";
    String displayDes = des ?? "0";
    String displayLoc = loc ?? "Unknown";
    String displayIcon = icon ?? "03n";
    String displayFeelsLike = feelsLike ?? "0";
    String displayTempMin = tempMin ?? "0";
    String displayTempMax = tempMax ?? "0";
    // ignore: unused_local_variable
    String displayMain = main ?? "Clear";

    IconData getWeatherIcon(String iconCode) {
      switch (iconCode) {
        case "01d": return Icons.wb_sunny;
        case "01n": return Icons.nightlight_round;
        case "02d": return Icons.wb_cloudy;
        case "02n": return Icons.nights_stay;
        case "03d":
        case "03n": return Icons.cloud;
        case "04d":
        case "04n": return Icons.wb_cloudy;
        case "09d":
        case "09n": return Icons.grain;
        case "10d":
        case "10n": return Icons.umbrella;
        case "11d":
        case "11n": return Icons.thunderstorm;
        case "13d":
        case "13n": return Icons.ac_unit;
        case "50d":
        case "50n": return Icons.foggy;
        default: return Icons.wb_sunny;
      }
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(backgroundColor: Colors.blue[200], elevation: 0),
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: _topAlignmentAnimation.value,
                    end: _bottomAlignmentAnimation.value,
                    colors: [
                      Colors.blue[200]!,
                      Colors.blue[400]!,
                      Colors.blue[600]!
                    ],
                  ),
                ),
                child: child,
              ),
            ),
          );
        },
        child: Column(
          children: [
              Container(
                //Search container
                padding: const EdgeInsets.symmetric(horizontal: 8),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (searchController.text.replaceAll(" ", "") != "") {
                          Navigator.pushReplacementNamed(context, "/loading",
                              arguments: {
                                "searchText": searchController.text,
                              });
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                        child: const Icon(Icons.search,
                            color: Colors.lightBlueAccent, size: 28),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onSubmitted: (value) {
                          if (value.replaceAll(" ", "") != "") {
                            Navigator.pushReplacementNamed(context, "/loading",
                                arguments: {
                                  "searchText": value,
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
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Image.network(
                            "https://openweathermap.org/img/wn/$displayIcon@2x.png",
                            height: 80,
                            width: 80,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported,
                                    color: Colors.white),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayDes,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          offset: Offset(2, 2))
                                    ],
                                  ),
                                ),
                                Text(
                                  "In $displayLoc",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white70,
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
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 2,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(getWeatherIcon(displayIcon),
                              size: 60, color: Colors.amberAccent),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(displayTemp,
                                      style: const TextStyle(
                                          fontSize: 70,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300)),
                                  Text("Feels Like $displayFeelsLike°C",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                              const SizedBox(width: 10),
                              const Text("°C",
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white70)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.arrow_upward,
                                  color: Colors.redAccent, size: 20),
                              Text(" $displayTempMax°C  ",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              const Icon(Icons.arrow_downward,
                                  color: Colors.blueAccent, size: 20),
                              Text(" $displayTempMin°C",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            ],
                          )
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
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          margin: const EdgeInsets.fromLTRB(20, 5, 10, 0),
                          padding: const EdgeInsets.all(26),
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.air,
                                      color: Colors.lightBlueAccent, size: 35)
                                ],
                              ),
                              const SizedBox(height: 25),
                              Text(
                                displayAir,
                                style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Text("km/h",
                                  style: TextStyle(color: Colors.white70)),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          margin: const EdgeInsets.fromLTRB(10, 5, 20, 0),
                          padding: const EdgeInsets.all(26),
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.water_drop,
                                      color: Colors.cyanAccent, size: 35)
                                ],
                              ),
                              const SizedBox(height: 25),
                              Text(
                                displayHum,
                                style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Text("Percent",
                                  style: TextStyle(color: Colors.white70)),
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
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Data Provided By OpenWeatherMap.Org",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}
