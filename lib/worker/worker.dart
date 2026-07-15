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
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$location&appid=681d7c1ea1998da88af9b913ab2c2543",
        ),
      );
      Map data = jsonDecode(response.body);
      // getting location
      String getlocation = data['name'];
      // getting temp and humidity
      Map tempData = data['main'];
      double gettemp = tempData['temp'] - 273.15;
      String gethumidity = tempData['humidity'].toString();
      // getting air speed
      Map windData = data['wind'];
      double getspeed = windData['speed'] / 0.27777777777778;

      // getting description
      List weatherData = data['weather'];
      String getdescription = weatherData[0]['description'];


      // assigning values
      temp = gettemp.toStringAsFixed(1);
      humidity = gethumidity;
      airSpeed = getspeed.toStringAsFixed(1);
      description = getdescription.toString();
      location = getlocation.toString();
      main = weatherData[0]['main'];
      icon = weatherData[0]["icon"].toString();
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
