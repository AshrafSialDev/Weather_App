import 'package:http/http.dart';
import 'dart:convert';

class Worker {
  String location;
  double? lat;
  double? lon;
  String temp;
  String humidity;
  String airSpeed;
  String description;
  String main;
  String icon;
  String feelsLike;
  String tempMin;
  String tempMax;

  Worker({
    this.location = "Unknown",
    this.lat,
    this.lon,
    this.temp = "0",
    this.humidity = "0",
    this.airSpeed = "0",
    this.description = "0",
    this.main = "0",
    this.icon = "03n",
    this.feelsLike = "0",
    this.tempMin = "0",
    this.tempMax = "0",
  });

  Future<void> getData() async {
    try {
      Map<String, String> queryParameters = {
        "appid": "681d7c1ea1998da88af9b913ab2c2543",
        "units": "metric",
      };

      if (lat != null && lon != null) {
        queryParameters["lat"] = lat.toString();
        queryParameters["lon"] = lon.toString();
      } else {
        queryParameters["q"] = location.trim();
      }

      Response response = await get(
        Uri.https("api.openweathermap.org", "/data/2.5/weather", queryParameters),
      );
      Map data = jsonDecode(response.body);

      if (data['cod'].toString() == "200") {
        // getting location
        String getlocation = data['name'] ?? "Unknown";
        // getting temp and humidity
        Map? tempData = data['main'];
        double gettemp = 0.0;
        double getFeelsLike = 0.0;
        double getTempMin = 0.0;
        double getTempMax = 0.0;
        String gethumidity = "0";
        if (tempData != null) {
          gettemp = (tempData['temp'] as num).toDouble();
          getFeelsLike = (tempData['feels_like'] as num).toDouble();
          getTempMin = (tempData['temp_min'] as num).toDouble();
          getTempMax = (tempData['temp_max'] as num).toDouble();
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
        feelsLike = getFeelsLike.toStringAsFixed(1);
        tempMin = getTempMin.toStringAsFixed(1);
        tempMax = getTempMax.toStringAsFixed(1);
        humidity = gethumidity;
        airSpeed = getspeed.toStringAsFixed(1);
        description = getdescription;
        location = getlocation;
        main = getmain;
        icon = geticon;
      } else {
        throw Exception("City/Location not found");
      }
    } catch (e) {
      temp = "NA";
      feelsLike = "NA";
      tempMin = "NA";
      tempMax = "NA";
      humidity = "NA";
      airSpeed = "NA";
      description = "Check Connection";
      main = "NA";
      icon= "11n";
      // location remains as what was passed in (e.g., "Lahore" or detected name)
    }
  }
}
