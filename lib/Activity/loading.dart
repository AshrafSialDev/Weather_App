import 'package:flutter/material.dart';
import 'package:flutter_application_1/worker/worker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String temp = "";
  String humidity = "";
  String airSpeed = "";
  String description = "";
  String location = "";
  String main = "";
  String icon = "";
  String feelsLike = "";
  String tempMin = "";
  String tempMax = "";
  bool isStarted = false;

  Future<void> startApp(String? city) async {
    if (isStarted) return;
    isStarted = true;

    Worker instance;

    if (city == null) {
      // Automatic detection
      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          instance = Worker(location: "Lahore");
        } else {
          LocationPermission permission = await Geolocator.checkPermission();
          
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
          }

          if (permission == LocationPermission.always || 
              permission == LocationPermission.whileInUse) {
            Position position = await Geolocator.getCurrentPosition(
                locationSettings: const LocationSettings(
                    accuracy: LocationAccuracy.low));
            instance = Worker(lat: position.latitude, lon: position.longitude);
          } else {
            // Either denied or deniedForever
            instance = Worker(location: "Lahore");
          }
        }
      } catch (e) {
        instance = Worker(location: "Lahore");
      }
    } else {
      // Search from Home
      instance = Worker(location: city);
    }

    await instance.getData();

    // Update all values from instance
    temp = instance.temp;
    humidity = instance.humidity;
    airSpeed = instance.airSpeed;
    description = instance.description;
    main = instance.main;
    location = instance.location;
    icon = instance.icon;
    feelsLike = instance.feelsLike;
    tempMin = instance.tempMin;
    tempMax = instance.tempMax;
    
    // Use the actual city from instance (resolved by API) for future refreshes
    String resolvedCity = instance.location;

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      '/home',
      arguments: {
        "temp_value": temp,
        "humidity_value": humidity,
        "airSpeed_value": airSpeed,
        "description_value": description,
        "main_value": main,
        "location_value": location,
        "icon_value": icon,
        "city_value": resolvedCity,
        "feels_like_value": feelsLike,
        "temp_min_value": tempMin,
        "temp_max_value": tempMax,
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map? search = ModalRoute.of(context)?.settings.arguments as Map?;
    String? city;
    if (search != null && search.containsKey('searchText')) {
      city = search['searchText'];
    }
    startApp(city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 150),
            Image.asset("images/logo3.png", height: 200, width: 200),
            const Text(
              "Weather Update",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Text(
              "A Product of Sial.Tech",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            const SpinKitFadingCircle(color: Colors.white, size: 50.0),
          ],
        ),
      ),
    );
  }
}
