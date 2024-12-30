import 'package:flutter/material.dart'; // Ensure the model file is imported here.
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lufickapp/Weather_APP/Forecast_weather_Api.dart';

// Main App Entry Point
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherForecastScreen(),
    );
  }
}

class WeatherForecastScreen extends StatefulWidget {
  @override
  State<WeatherForecastScreen> createState() => _WeatherForecastScreenState();
}

class _WeatherForecastScreenState extends State<WeatherForecastScreen> {
  Future<Forecastnoaqiandalerts?> fetchForecastWeather(dynamic data) async {
    const String apiKey = "7d9146bb8a634bf38cd65757243012";
    const String baseUrl = "http://api.weatherapi.com/v1/forecast.json";
    String query = data;

    try {
      final response = await http.get(
        Uri.parse("$baseUrl?key=$apiKey&q=$query&days=7&aqi=no&alerts=no"),
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Forecastnoaqiandalerts.fromJson(jsonData);
      } else {
        print("Failed to fetch data. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("An error occurred: $e");
      return null;
    }
  }
  TextEditingController searchcontroller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        onPressed: (){

          setState(() {
            fetchForecastWeather(searchcontroller.text.toString().trim());
          });
        },child: Icon(Icons.search,color: Colors.white,),),
      appBar: AppBar(
        title: Text('Weather Forecast'),
        centerTitle: true,
      ),
      body: FutureBuilder<Forecastnoaqiandalerts?>(
        future: fetchForecastWeather("Panipat"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available.'));
          } else {
            final forecast = snapshot.data!;
            return ListView(
              padding: EdgeInsets.all(8.0),
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter City Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      fetchForecastWeather(value);
                    });
                  },
                ),

                if (forecast.location != null)
                  buildLocationCard(forecast.location!),
                if (forecast.forecast != null &&
                    forecast.forecast!.forecastday != null)
                  ...forecast.forecast!.forecastday!.map(
                        (forecastDay) => buildForecastCard(forecastDay),
                  ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget buildLocationCard(Location location) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${location.name}, ${location.region}, ${location.country}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Latitude: ${location.lat}, Longitude: ${location.lon}'),
            Text('Timezone: ${location.tzId}'),
            Text('Local Time: ${location.localtime}'),
          ],
        ),
      ),
    );
  }

  Widget buildForecastCard(Forecastday forecastDay) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${forecastDay.date ?? ''}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            if (forecastDay.day != null) ...[
              Text('Max Temp: ${forecastDay.day!.maxtempC}°C'),
              Text('Min Temp: ${forecastDay.day!.mintempC}°C'),
            ],
          ],
        ),
      ),
    );
  }
}
