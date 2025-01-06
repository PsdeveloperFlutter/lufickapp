import 'package:flutter/widgets.dart' as ps;
import 'package:flutter/material.dart';
import 'package:lufickapp/Weather_APP/Future_weather_API.dart';

ps.TextEditingController searchcontroller = ps.TextEditingController();
class  futureweatherscreen  extends ps.StatefulWidget {
  @override
  ps.State<futureweatherscreen> createState() => _futureweatherscreenState();
}

class _futureweatherscreenState extends ps.State<futureweatherscreen> {

  late Future<Futureweather> weatherData ;
  void initState() {
    super.initState();
    weatherData= fetchFutureWeather("London");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        onPressed: (){
         setState(() {
           weatherData=fetchFutureWeather(searchcontroller.text.toString().trim());
         });
      },
      child: ps.Icon(Icons.search,color: Colors.white,),),
      appBar: AppBar(
        title: ps.Text("Future Weather"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future:weatherData ,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: ps.Text(
                "Error loading weather data. Please try again later.",
                style: TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ps.ListView(
                children: [
                  ps.Padding(
                    padding:EdgeInsets.all(5.0),
                    child: TextField(
                      controller: searchcontroller,
                      decoration: InputDecoration(
                        labelText: "Enter City Name",
                        labelStyle:ps.TextStyle(
                          color: Colors.black,
                         fontSize: 16
                        ) ,
                        hintText: "Enter City Name",
                        hintStyle:ps.TextStyle(
                            color: Colors.black,
                            fontSize: 16
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),

                        ),
                        suffixIconColor: Colors.blue,
                        fillColor: Colors.white,
                        filled: true,
                        suffixIcon: IconButton(
                          icon: ps.Icon(Icons.search),
                          onPressed: () {
                            // Perform search logic here
                          },
                        ),
                      ),
                    ),
                  ),
                  ps.SizedBox(height:12),
                  Card(
                    elevation: 5,
                    child: ps.ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ps.Image.network(
                        "https:${data.forecast.forecastday[0].day.condition.icon}",
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  Card(
                    elevation: 5,
                    child: ps.Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ps.Column(
                        children: [

                          ps.Text(
                            data.location.name,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),


                          ps.Text(
                            "${data.location.region}, ${data.location.country}",
                            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                          ),
                          SizedBox(height: 16),
                          ps.Text(
                            "Local Time: ${data.location.localtime}",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          ps.Text(
                            "Latitude: ${data.location.lat}, Longitude: ${data.location.lon}",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          ps.Text(
                            "Timezone: ${data.location.tzId}",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          ps.Text(
                            "Epoch Time: ${data.location.localtimeEpoch}",
                            style: TextStyle(fontSize: 16),
                          ),
                          ps.Text(
                            "Sunrise: ${data.forecast.forecastday[0].astro.sunrise}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),

                  ps.SizedBox(height: 12,),


                  Card(
                    child: ps.Column(
                      children: [
                      ps.Text("Astro",style: ps.TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    ps.SizedBox(height: 12,),
                    ps.Text(
                      "SunSet: ${data.forecast.forecastday[0].astro.sunset}",
                      style: TextStyle(fontSize: 16),
                    ),
                    ps.Text(
                      "MonRise: ${data.forecast.forecastday[0].astro.moonrise}",
                      style: TextStyle(fontSize: 16),
                    ),
                    ps.Text(
                      "MoonSet: ${data.forecast.forecastday[0].astro.moonset}",
                      style: TextStyle(fontSize: 16),
                    ),
                    ps.Text(
                      "MoonPhase: ${data.forecast.forecastday[0].astro.moonPhase}",
                      style: TextStyle(fontSize: 16),
                    ),
                    ps.Text(
                      "MoonIllumination: ${data.forecast.forecastday[0].astro.moonIllumination}",
                      style: TextStyle(fontSize: 16),
                    ),


                    ps.Text(
                      "Temperature: ${data.forecast.forecastday[0].day.avgtempC}°C "
                          "/ ${data.forecast.forecastday[0].day.avgtempF}°F",
                      style: TextStyle(fontSize: 16),)

                    ,
                    ps.Text(
                      "Max Temperature: ${data.forecast.forecastday[0].day.maxtempC}°C "
                          "/ ${data.forecast.forecastday[0].day.maxtempF}°F",
                      style: TextStyle(fontSize: 16),
                    )
                    ,
                    ps.Text(
                      "Min Temperature: ${data.forecast.forecastday[0].day.mintempC}°C "
                          "/ ${data.forecast.forecastday[0].day.mintempF}°F",
                      style: TextStyle(fontSize: 16),
                    )

                    ,
                    SizedBox(height: 16),
                    ps.Text(
                      "Max Wind (kph): ${data.forecast.forecastday[0].day.maxwindKph}",
                      style: ps.TextStyle(fontSize: 16),
                    ),
                    ps.Text(
                      "Max Wind (mph): ${data.forecast.forecastday[0].day.maxwindMph}",
                      style: ps.TextStyle(fontSize: 16),
                    ),
                    ps.Text(
                      "Total Precipitation (mm): ${data.forecast.forecastday[0].day.totalprecipMm}",
                      style: ps.TextStyle(fontSize: 16),
                    ),
                    ps.Text(
                      "Total Precipitation (in): ${data.forecast.forecastday[0].day.totalprecipIn}",
                      style: ps.TextStyle(fontSize: 16),
                    ),
                      ],
                    ),
                  ),

                  ps.SizedBox(height: 12,),
                   Card(
                     elevation: 5,
                     child: ps.Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: ps.Column(
                         children: [
                           ps.Text("Condition",style: ps.TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                           ps.SizedBox(height: 12,),

                           ps.Text(
                             "Condition: ${data.forecast.forecastday[0].day.condition.text}",
                             style: TextStyle(fontSize: 16),
                           )
                         ],
                       ),
                     ),
                   ),
                  ps.SizedBox(height: 12,),

                  Card(
                    elevation: 5,
                    child: ps.Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ps.Column(
                        children: [
                          ps.Text(
                            "Hourly",
                            style: ps.TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ps.SizedBox(height: 12),
                          ps.Text(
                            "Time: ${data.forecast.forecastday[0].hour[0].time}",
                          ),
                          ps.Text(
                            "Condition: ${data.forecast.forecastday[0].hour[0].condition.text}",
                          ),
                          ps.Text(
                            "Temp: ${data.forecast.forecastday[0].hour[0].tempC}°C / ${data.forecast.forecastday[0].hour[0].tempF}°F",
                          ),
                          ps.Text(
                            "FeelsLike: ${data.forecast.forecastday[0].hour[0].feelslikeC}°C / ${data.forecast.forecastday[0].hour[0].feelslikeF}°F",
                          ),
                          ps.Text(
                            "Wind KPH: ${data.forecast.forecastday[0].hour[0].windKph}",
                          ),
                          ps.Text(
                            "Wind MPH: ${data.forecast.forecastday[0].hour[0].windMph}",
                          ),
                          ps.Text(
                            "Precip MM: ${data.forecast.forecastday[0].hour[0].precipMm}",
                          ),
                          ps.Text(
                            "Precip IN: ${data.forecast.forecastday[0].hour[0].precipIn}",
                          ),
                          ps.Text(
                            "Humidity: ${data.forecast.forecastday[0].hour[0].humidity}",
                          ),
                          ps.Text(
                            "Cloud: ${data.forecast.forecastday[0].hour[0].cloud}",
                          ),
                          ps.Text(
                            "Will It Rain: ${data.forecast.forecastday[0].hour[0].willItRain}",
                          ),
                          ps.Text(
                            "Will It Snow: ${data.forecast.forecastday[0].hour[0].willItSnow}",
                          ),
                          ps.Text(
                            "UV: ${data.forecast.forecastday[0].hour[0].uv}",
                          ),
                          ps.Text(
                            "Gust KPH: ${data.forecast.forecastday[0].hour[0].gustKph}",
                          ),
                          ps.Text(
                            "Gust MPH: ${data.forecast.forecastday[0].hour[0].gustMph}",
                          ),
                        ],
                      ),
                    ),
                  ),

                  ps.SizedBox(height: 12,),
                  Card(
                    elevation: 5,
                    child: ps.Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ps.Column(
                        children: [
                          ps.Text(
                            "Day",
                            style: ps.TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ps.SizedBox(height: 12),
                          ps.Text(
                            "Max Temp: ${data.forecast.forecastday[0].day.maxtempC}°C / ${data.forecast.forecastday[0].day.maxtempF}°F",
                          ),
                          ps.Text(
                            "Min Temp: ${data.forecast.forecastday[0].day.mintempC}°C / ${data.forecast.forecastday[0].day.mintempF}°F",
                          ),
                          ps.Text(
                            "Avg Temp: ${data.forecast.forecastday[0].day.avgtempC}°C / ${data.forecast.forecastday[0].day.avgtempF}°F",
                          ),
                          ps.Text(
                            "Condition: ${data.forecast.forecastday[0].day.condition.text}",
                          ),
                          ps.Text(
                            "Humidity: ${data.forecast.forecastday[0].day.avghumidity}",
                          ),
                          ps.Text(
                            "UV: ${data.forecast.forecastday[0].day.uv}",
                          ),
                          ps.Text(
                            "Precip MM: ${data.forecast.forecastday[0].day.totalprecipMm}",
                          ),
                          ps.Text(
                            "Precip IN: ${data.forecast.forecastday[0].day.totalprecipIn}",
                          ),
                          ps.Text(
                            "Sunrise: ${data.forecast.forecastday[0].astro.sunrise}",
                          ),
                          ps.Text(
                            "Sunset: ${data.forecast.forecastday[0].astro.sunset}",
                          ),
                        ],
                      ),
                    ),
                  ),


                ],
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
