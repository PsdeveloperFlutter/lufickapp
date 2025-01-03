import 'package:flutter/widgets.dart' as ps;
import 'package:flutter/material.dart';
import 'package:lufickapp/Weather_APP/Future_weather_API.dart';

class  futureweatherscreen  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ps.Text("Future Weather"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: fetchFutureWeather("London"),
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
                  ps.Image.network(
                    "https:${data.forecast.forecastday[0].day.condition.icon}",
                    height: 100,
                    width: 100,
                  ),

                  SizedBox(height: 16),
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

                  ps.SizedBox(height: 12,),
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

                  ps.SizedBox(height: 12,),
                  ps.Text("Condition",style: ps.TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  ps.SizedBox(height: 12,),

                  ps.Text(
                    "Condition: ${data.forecast.forecastday[0].day.condition.text}",
                    style: TextStyle(fontSize: 16),
                  )
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
