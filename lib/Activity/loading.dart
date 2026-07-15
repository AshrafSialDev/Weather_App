import 'package:flutter/material.dart';
import 'package:flutter_application_1/worker/worker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String city= "lahore";
  String temp = "";
  String humidity = "";
  String airSpeed = "";
  String description = "";
  String location = "";
  String main = "";
  String icon = "";
  bool isStarted = false;

  void startApp(String city) async {
    if (isStarted) return;
    isStarted = true;

    Worker instance = Worker(location: city);
    await instance.getData();

    // Update all values from instance
    temp = instance.temp;
    humidity = instance.humidity;
    airSpeed = instance.airSpeed;
    description = instance.description;
    main = instance.main;
    location = instance.location;
    icon = instance.icon;
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    // Navigate to /home instead of /loading to stop the infinite loop
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
        "city_value" : city,
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map? search = ModalRoute.of(context)?.settings.arguments as Map?;
    String city = "Lahore";
    if (search?.isNotEmpty ?? false) {
      city = search!['searchText'];
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
            SizedBox(height: 150),
            Image.asset("images/logo3.png", height: 200, width: 200),
            Text(
              "Weather Update",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "A Product of Sial.Tech",
              style: TextStyle(fontSize: 12, color: Colors.white,
              fontWeight: FontWeight.bold ),
            ),
            SizedBox(height: 30),
            SpinKitFadingCircle(color: Colors.white, size: 50.0),
          ],
        ),
      ),
    );
  }
}
