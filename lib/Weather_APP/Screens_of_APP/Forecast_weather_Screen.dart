import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Forecast_weather_Api.dart';

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
  final TextEditingController searchController = TextEditingController();
  Future<Forecastnoaqiandalerts?>? futureWeather;
  String query = "Panipat"; // Default city for the initial load.

  // Fetch weather data from API
  Future<Forecastnoaqiandalerts?> fetchForecastWeather(String query) async {
    const String apiKey = "7d9146bb8a634bf38cd65757243012";
    const String baseUrl = "http://api.weatherapi.com/v1/forecast.json";

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

  @override
  void initState() {
    super.initState();
    futureWeather = fetchForecastWeather(query); // Load default city.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Forecast'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search Field
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Enter City Name',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchWeather();
                  },
                ),
              ),
              onSubmitted: (_) => _searchWeather(),
            ),
            SizedBox(height: 16),

            // Weather Data
            Expanded(
              child: FutureBuilder<Forecastnoaqiandalerts?>(
                future: futureWeather,
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
                      children: [
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        onPressed: _searchWeather,
        child: Icon(Icons.search, color: Colors.white),
      ),
    );
  }

  // Search Weather Function
  void _searchWeather() {
    if (searchController.text.trim().isNotEmpty) {
      setState(() {
        query = searchController.text.trim();
        futureWeather = fetchForecastWeather(query);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a city name')),
      );
    }
  }

  // Build Location Card
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

  // Build Forecast Card
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
