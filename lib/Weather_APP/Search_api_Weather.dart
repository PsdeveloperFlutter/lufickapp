// To parse this JSON data, do
//
//     final searchweather = searchweatherFromJson(jsonString);

import 'dart:convert';
import 'package:http/http.dart'as http;
Searchweather searchweatherFromJson(String str) => Searchweather.fromJson(json.decode(str));

String searchweatherToJson(Searchweather data) => json.encode(data.toJson());

class Searchweather {
  Searchweather({
    required this.location,
    required this.current,
    required this.forecast,
    required this.alerts,
  });

  final Location location;
  final Current current;
  final Forecast forecast;
  final Alerts alerts;

  factory Searchweather.fromJson(Map<String, dynamic> json) => Searchweather(
    location: Location.fromJson(json["location"]),
    current: Current.fromJson(json["current"]),
    forecast: Forecast.fromJson(json["forecast"]),
    alerts: Alerts.fromJson(json["alerts"]),
  );

  Map<String, dynamic> toJson() => {
    "location": location.toJson(),
    "current": current.toJson(),
    "forecast": forecast.toJson(),
    "alerts": alerts.toJson(),
  };
}

class Location {
  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.tzId,
    required this.localtimeEpoch,
    required this.localtime,
  });

  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String tzId;
  final int localtimeEpoch;
  final String localtime;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    name: json["name"],
    region: json["region"],
    country: json["country"],
    lat: json["lat"].toDouble(),
    lon: json["lon"].toDouble(),
    tzId: json["tz_id"],
    localtimeEpoch: json["localtime_epoch"],
    localtime: json["localtime"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "region": region,
    "country": country,
    "lat": lat,
    "lon": lon,
    "tz_id": tzId,
    "localtime_epoch": localtimeEpoch,
    "localtime": localtime,
  };
}

class Current {
  Current({
    required this.tempC,
    required this.tempF,
    required this.condition,
    required this.windMph,
    required this.windKph,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.feelslikeF,
  });

  final double tempC;
  final double tempF;
  final Condition condition;
  final double windMph;
  final double windKph;
  final int humidity;
  final int cloud;
  final double feelslikeC;
  final double feelslikeF;

  factory Current.fromJson(Map<String, dynamic> json) => Current(
    tempC: json["temp_c"].toDouble(),
    tempF: json["temp_f"].toDouble(),
    condition: Condition.fromJson(json["condition"]),
    windMph: json["wind_mph"].toDouble(),
    windKph: json["wind_kph"].toDouble(),
    humidity: json["humidity"],
    cloud: json["cloud"],
    feelslikeC: json["feelslike_c"].toDouble(),
    feelslikeF: json["feelslike_f"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "temp_c": tempC,
    "temp_f": tempF,
    "condition": condition.toJson(),
    "wind_mph": windMph,
    "wind_kph": windKph,
    "humidity": humidity,
    "cloud": cloud,
    "feelslike_c": feelslikeC,
    "feelslike_f": feelslikeF,
  };
}

class Condition {
  Condition({
    required this.text,
    required this.icon,
    required this.code,
  });

  final String text;
  final String icon;
  final int code;

  factory Condition.fromJson(Map<String, dynamic> json) => Condition(
    text: json["text"],
    icon: json["icon"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "icon": icon,
    "code": code,
  };
}

class Forecast {
  Forecast({
    required this.forecastday,
  });

  final List<Forecastday> forecastday;

  factory Forecast.fromJson(Map<String, dynamic> json) => Forecast(
    forecastday: List<Forecastday>.from(
        json["forecastday"].map((x) => Forecastday.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "forecastday": List<dynamic>.from(forecastday.map((x) => x.toJson())),
  };
}

class Forecastday {
  Forecastday({
    required this.date,
    required this.dateEpoch,
    required this.day,
  });

  final String date;
  final int dateEpoch;
  final Day day;

  factory Forecastday.fromJson(Map<String, dynamic> json) => Forecastday(
    date: json["date"],
    dateEpoch: json["date_epoch"],
    day: Day.fromJson(json["day"]),
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "date_epoch": dateEpoch,
    "day": day.toJson(),
  };
}


class Day {
  dynamic maxtempC;
  dynamic maxtempF;
  dynamic mintempC;
  dynamic mintempF;
  dynamic avgtempC;
  dynamic avgtempF;
  dynamic maxwindMph;
  dynamic maxwindKph;
  dynamic totalprecipMm;
  dynamic totalprecipIn;
  dynamic totalsnowCm;
  dynamic avgvisKm;
  dynamic avgvisMiles;
  dynamic avghumidity;
  dynamic dailyWillItRain;
  dynamic dailyChanceOfRain;
  dynamic dailyWillItSnow;
  dynamic dailyChanceOfSnow;
  Condition condition;
  double uv;
  Map<String, double> airQuality;

  Day({
    required this.maxtempC,
    required this.maxtempF,
    required this.mintempC,
    required this.mintempF,
    required this.avgtempC,
    required this.avgtempF,
    required this.maxwindMph,
    required this.maxwindKph,
    required this.totalprecipMm,
    required this.totalprecipIn,
    required this.totalsnowCm,
    required this.avgvisKm,
    required this.avgvisMiles,
    required this.avghumidity,
    required this.dailyWillItRain,
    required this.dailyChanceOfRain,
    required this.dailyWillItSnow,
    required this.dailyChanceOfSnow,
    required this.condition,
    required this.uv,
    required this.airQuality,
  });

  factory Day.fromJson(Map<String, dynamic> json) => Day(
    maxtempC: json["maxtemp_c"]?.toDouble(),
    maxtempF: json["maxtemp_f"]?.toDouble(),
    mintempC: json["mintemp_c"]?.toDouble(),
    mintempF: json["mintemp_f"]?.toDouble(),
    avgtempC: json["avgtemp_c"],
    avgtempF: json["avgtemp_f"]?.toDouble(),
    maxwindMph: json["maxwind_mph"]?.toDouble(),
    maxwindKph: json["maxwind_kph"]?.toDouble(),
    totalprecipMm: json["totalprecip_mm"],
    totalprecipIn: json["totalprecip_in"],
    totalsnowCm: json["totalsnow_cm"],
    avgvisKm: json["avgvis_km"],
    avgvisMiles: json["avgvis_miles"],
    avghumidity: json["avghumidity"],
    dailyWillItRain: json["daily_will_it_rain"],
    dailyChanceOfRain: json["daily_chance_of_rain"],
    dailyWillItSnow: json["daily_will_it_snow"],
    dailyChanceOfSnow: json["daily_chance_of_snow"],
    condition: Condition.fromJson(json["condition"]),
    uv: json["uv"]?.toDouble(),
    airQuality: Map.from(json["air_quality"]).map((k, v) => MapEntry<String, double>(k, v?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "maxtemp_c": maxtempC,
    "maxtemp_f": maxtempF,
    "mintemp_c": mintempC,
    "mintemp_f": mintempF,
    "avgtemp_c": avgtempC,
    "avgtemp_f": avgtempF,
    "maxwind_mph": maxwindMph,
    "maxwind_kph": maxwindKph,
    "totalprecip_mm": totalprecipMm,
    "totalprecip_in": totalprecipIn,
    "totalsnow_cm": totalsnowCm,
    "avgvis_km": avgvisKm,
    "avgvis_miles": avgvisMiles,
    "avghumidity": avghumidity,
    "daily_will_it_rain": dailyWillItRain,
    "daily_chance_of_rain": dailyChanceOfRain,
    "daily_will_it_snow": dailyWillItSnow,
    "daily_chance_of_snow": dailyChanceOfSnow,
    "condition": condition.toJson(),
    "uv": uv,
    "air_quality": Map.from(airQuality).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };
}


class Alerts {
  Alerts({
    required this.alert,
  });

  final List<dynamic> alert;

  factory Alerts.fromJson(Map<String, dynamic> json) => Alerts(
    alert: List<dynamic>.from(json["alert"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "alert": List<dynamic>.from(alert.map((x) => x)),
  };
}

Future<Searchweather?>searchapiweather()async{
  try{
    final response=await http.get(Uri.parse("http://api.weatherapi.com/v1/forecast.json?key=7d9146bb8a634bf38cd65757243012&q=London&days=1&aqi=yes&alerts=yes"));
    if(response.statusCode==200){
      return Searchweather.fromJson(jsonDecode(response.body));
    }else{
      throw Exception("Failed to fetch data");
    }

  }

  catch(e){
    print("$e Error Occur");
  }
  return null;
}