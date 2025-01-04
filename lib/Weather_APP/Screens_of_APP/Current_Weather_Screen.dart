import 'package:flutter/material.dart';
import 'package:lufickapp/Weather_APP/Current_Weather_API.dart';
import 'package:lufickapp/Weather_APP/Screens_of_APP/Future_weather_Screen.dart';

import 'Forecast_weather_Screen.dart';
import 'Google_authentication.dart';
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

  TextEditingController searchController=TextEditingController();
  @override
  void initState() {
    super.initState();
    weatherData = fetchCurrentWeather("Panipat"); // Fetch weather data on app start
  }

  void dispose() {
    super.dispose();
    weatherData = null;
    searchController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        onPressed: (){
          setState(() {
            weatherData = fetchCurrentWeather(searchController.text.toString().trim());
          });
        },
        child: Icon(Icons.search,color: Colors.white,),
      ),
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.menu, size: 30, color: Colors.blue),
            offset: Offset(0, 40),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            itemBuilder: (context) => [

              PopupMenuItem(
                value: 'Search',
                child: Row(
                  children: [
                    Icon(Icons.timeline, size: 20, color: Colors.blue.shade700),
                    SizedBox(width: 10),
                    Text('Future', style: TextStyle(fontSize: 16, color: Colors.black)),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: (){
                  GooglesignClass.handleSignOut(context);
                },
                value: 'Logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20, color: Colors.blue.shade700),
                    SizedBox(width: 10),
                    Text('Logout', style: TextStyle(fontSize: 16, color: Colors.black)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'Home') {
                // Navigate to Home screen
              } else if (value == 'Search') {
        Navigator.push(context,MaterialPageRoute(builder: (context) => futureweatherscreen()));

              } else if (value == 'Settings') {
                // Navigate to Settings screen
              }
            },
          )
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
                    SizedBox(height: 16),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search for weather',
                        hintStyle: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 12),
                          labelStyle: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),
                          label: Text('Search for weather'),
                          prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        fillColor: Colors.white,
                        filled: true,
                      //  prefixStyle: TextStyle(color: Colors.blue.shade700,fontWeight: FontWeight.bold),
                        prefixIconColor: Colors.blue.shade700
                      ),
                    ),
                    SizedBox(height:10),
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
