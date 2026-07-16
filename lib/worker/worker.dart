//class having different methods
//instances having different data
import 'package:http/http.dart';
import 'dart:convert';

class Worker {
  String location;
  String temp;
  String humidity;
  String airSpeed;
  String description;
  String main;
  String icon;
  Worker({
    required this.location,
    this.temp = "0",
    this.humidity = "0",
    this.airSpeed = "0",
    this.description = "0",
    this.main = "0",
    this.icon="03n",
  });

  //method
  //async function start but return after set delay
  // Future.delayed method start after set delay
  Future<void> getData() async {
    try {
      Response response = await get(
        Uri.https("api.openweathermap.org", "/data/2.5/weather", {
          "q": location.trim(),
          "appid": "681d7c1ea1998da88af9b913ab2c2543",
          "units": "metric",
        }),
      );
      Map data = jsonDecode(response.body);

      if (data['cod'].toString() == "200") {
        // getting location
        String getlocation = data['name'] ?? "Unknown";
        // getting temp and humidity
        Map? tempData = data['main'];
        double gettemp = 0.0;
        String gethumidity = "0";
        if (tempData != null) {
          gettemp = (tempData['temp'] as num).toDouble();
          gethumidity = tempData['humidity'].toString();
        }
        
        // getting air speed
        Map? windData = data['wind'];
        double getspeed = 0.0;
        if (windData != null) {
          getspeed = (windData['speed'] as num).toDouble() * 3.6;
        }

        // getting description
        List? weatherData = data['weather'];
        String getdescription = "No description";
        String getmain = "Clear";
        String geticon = "03n";
        if (weatherData != null && weatherData.isNotEmpty) {
          getdescription = weatherData[0]['description'] ?? "No description";
          getmain = weatherData[0]['main'] ?? "Clear";
          geticon = weatherData[0]["icon"] ?? "03n";
        }

        // assigning values
        temp = gettemp.toStringAsFixed(1);
        humidity = gethumidity;
        airSpeed = getspeed.toStringAsFixed(1);
        description = getdescription;
        location = getlocation;
        main = getmain;
        icon = geticon;
      } else {
        throw Exception("City not found");
      }
    } catch (e) {
      temp = "NA";
      humidity = "NA";
      airSpeed = "NA";
      description = "Can't find data";
      location = "Can't find";
      main = "NA";
      icon= "03n";
    }
  }
}

Worker instance = Worker(location: "Lahore");
