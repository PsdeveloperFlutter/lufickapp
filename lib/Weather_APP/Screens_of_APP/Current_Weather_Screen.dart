import 'package:flutter/material.dart';
import 'package:lufickapp/Weather_APP/Current_Weather_API.dart';

import 'Forecast_weather_Screen.dart';
import 'Search_Screen.dart';

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  Future<Currenttemp?>? weatherData;

  @override
  void initState() {
    super.initState();
    weatherData = fetchCurrentWeather(); // Fetch weather data on app start
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        onPressed: (){
          setState(() {
            weatherData = fetchCurrentWeather();
          });
        },
        child: Icon(Icons.search,color: Colors.white,),
      ),
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>searchScreen()));
          }, icon: Icon(Icons.more_vert))
        ],
        title: Text('Weather App'),
        centerTitle: true,
      ),
      body: FutureBuilder<Currenttemp?>(
        future: weatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No weather data available.'));
          } else {
            final weather = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      weather.location.name,
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${weather.location.region}, ${weather.location.country}',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 16),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Weather Icon
                            Image.network(
                              'https:${weather.current.condition.icon}',
                              width: 64,
                              height: 64,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error, size: 64, color: Colors.red);
                              },
                            ),
                            SizedBox(width: 16),
                            // Weather Details
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${weather.current.tempC}°C',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  weather.current.condition.text,
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Feels like: ${weather.current.feelslikeC}°C',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Additional Info
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Additional Info',
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  Text('Wind: ${weather.current.windKph} kph'),
                                  Text('Humidity: ${weather.current.humidity}%'),
                                  Text('UV Index: ${weather.current.uv}'),
                                  Text('Visibility: ${weather.current.visKm} km'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),

      //Bottom Navigation Bar
      //Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.cyanAccent,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => searchScreen()));
          }
          else if(index == 2){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>WeatherForecastScreen()));
          }
          else if(index == 0){

          }
        },
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black,),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.black),
            label: 'Search',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz, color: Colors.black),
            label: 'Forecast',
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(WeatherApp());
}
