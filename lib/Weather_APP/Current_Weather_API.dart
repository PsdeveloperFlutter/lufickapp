import 'package:http/http.dart' as http;
import 'dart:convert';

//This is the api Call for current weather Data
Future<Currenttemp?> fetchCurrentWeather(dynamic location) async {
  const String apiKey = "1e664b5ce1294e4aa9d65423243012";
  const String baseUrl = "http://api.weatherapi.com/v1/current.json";

  try {
    final response = await http.get(
      Uri.parse("$baseUrl?key=$apiKey&q=$location&aqi=no"),
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      return Currenttemp.fromJson(json.decode(response.body));
    } else {
      print("Failed to fetch data. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error occurred: $e");
  }

  return null; // Return null if there's an error
}




// Classes for JSON Mapping
Currenttemp currenttempFromJson(String str) =>
    Currenttemp.fromJson(json.decode(str));

String currenttempToJson(Currenttemp data) => json.encode(data.toJson());

class Currenttemp {
  final Location location;
  final Current current;

  Currenttemp({
    required this.location,
    required this.current,
  });

  factory Currenttemp.fromJson(Map<String, dynamic> json) {
    return Currenttemp(
      location: Location.fromJson(json["location"]),
      current: Current.fromJson(json["current"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "location": location.toJson(),
    "current": current.toJson(),
  };
}

// Location Class
class Location {
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String tzId;
  final int localtimeEpoch;
  final String localtime;

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

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json["name"],
      region: json["region"],
      country: json["country"],
      lat: json["lat"]?.toDouble(),
      lon: json["lon"]?.toDouble(),
      tzId: json["tz_id"],
      localtimeEpoch: json["localtime_epoch"],
      localtime: json["localtime"],
    );
  }

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

// Current Weather Class
class Current {
  final dynamic lastUpdatedEpoch;
  final dynamic lastUpdated;
  final dynamic tempC;
  final dynamic tempF;
  final dynamic isDay;
  final dynamic condition;
  final dynamic windMph;
  final dynamic windKph;
  final dynamic windDegree;
  final dynamic windDir;
  final dynamic pressureMb;
  final dynamic pressureIn;
  final dynamic precipMm;
  final dynamic precipIn;
  final dynamic humidity;
  final dynamic cloud;
  final dynamic feelslikeC;
  final dynamic feelslikeF;
  final dynamic windchillC;
  final dynamic windchillF;
  final dynamic heatindexC;
  final dynamic heatindexF;
  final dynamic dewpointC;
  final dynamic dewpointF;
  final dynamic visKm;
  final dynamic visMiles;
  final dynamic uv;
  final dynamic gustMph;
  final dynamic gustKph;

  Current({
    required this.lastUpdatedEpoch,
    required this.lastUpdated,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.condition,
    required this.windMph,
    required this.windKph,
    required this.windDegree,
    required this.windDir,
    required this.pressureMb,
    required this.pressureIn,
    required this.precipMm,
    required this.precipIn,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.feelslikeF,
    required this.windchillC,
    required this.windchillF,
    required this.heatindexC,
    required this.heatindexF,
    required this.dewpointC,
    required this.dewpointF,
    required this.visKm,
    required this.visMiles,
    required this.uv,
    required this.gustMph,
    required this.gustKph,
  });

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      lastUpdatedEpoch: json["last_updated_epoch"],
      lastUpdated: json["last_updated"],
      tempC: json["temp_c"]?.toDouble(),
      tempF: json["temp_f"]?.toDouble(),
      isDay: json["is_day"],
      condition: Condition.fromJson(json["condition"]),
      windMph: json["wind_mph"]?.toDouble(),
      windKph: json["wind_kph"]?.toDouble(),
      windDegree: json["wind_degree"],
      windDir: json["wind_dir"],
      pressureMb: json["pressure_mb"],
      pressureIn: json["pressure_in"]?.toDouble(),
      precipMm: json["precip_mm"],
      precipIn: json["precip_in"],
      humidity: json["humidity"],
      cloud: json["cloud"],
      feelslikeC: json["feelslike_c"]?.toDouble(),
      feelslikeF: json["feelslike_f"]?.toDouble(),
      windchillC: json["windchill_c"]?.toDouble(),
      windchillF: json["windchill_f"]?.toDouble(),
      heatindexC: json["heatindex_c"]?.toDouble(),
      heatindexF: json["heatindex_f"]?.toDouble(),
      dewpointC: json["dewpoint_c"]?.toDouble(),
      dewpointF: json["dewpoint_f"]?.toDouble(),
      visKm: json["vis_km"]?.toDouble(),
      visMiles: json["vis_miles"],
      uv: json["uv"]?.toDouble(),
      gustMph: json["gust_mph"]?.toDouble(),
      gustKph: json["gust_kph"]?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    "last_updated_epoch": lastUpdatedEpoch,
    "last_updated": lastUpdated,
    "temp_c": tempC,
    "temp_f": tempF,
    "is_day": isDay,
    "condition": condition.toJson(),
    "wind_mph": windMph,
    "wind_kph": windKph,
    "wind_degree": windDegree,
    "wind_dir": windDir,
    "pressure_mb": pressureMb,
    "pressure_in": pressureIn,
    "precip_mm": precipMm,
    "precip_in": precipIn,
    "humidity": humidity,
    "cloud": cloud,
    "feelslike_c": feelslikeC,
    "feelslike_f": feelslikeF,
    "windchill_c": windchillC,
    "windchill_f": windchillF,
    "heatindex_c": heatindexC,
    "heatindex_f": heatindexF,
    "dewpoint_c": dewpointC,
    "dewpoint_f": dewpointF,
    "vis_km": visKm,
    "vis_miles": visMiles,
    "uv": uv,
    "gust_mph": gustMph,
    "gust_kph": gustKph,
  };
}

// Condition Class
class Condition {
  final String text;
  final String icon;
  final int code;

  Condition({
    required this.text,
    required this.icon,
    required this.code,
  });

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      text: json["text"],
      icon: json["icon"],
      code: json["code"],
    );
  }

  Map<String, dynamic> toJson() => {
    "text": text,
    "icon": icon,
    "code": code,
  };
}
