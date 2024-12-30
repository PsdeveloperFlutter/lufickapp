import 'dart:convert';
import 'package:http/http.dart' as http;

// Main class representing the forecast
class Forecastnoaqiandalerts {
  Location? location;
  Current? current;
  Forecast? forecast;

  Forecastnoaqiandalerts({this.location, this.current, this.forecast});

  // From JSON
  factory Forecastnoaqiandalerts.fromJson(Map<String, dynamic> json) {
    return Forecastnoaqiandalerts(
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      current: json['current'] != null ? Current.fromJson(json['current']) : null,
      forecast: json['forecast'] != null ? Forecast.fromJson(json['forecast']) : null,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() => {
    'location': location?.toJson(),
    'current': current?.toJson(),
    'forecast': forecast?.toJson(),
  };
}

// Class for location details
class Location {
  String? name;
  String? region;
  String? country;
  double? lat;
  double? lon;
  String? tzId;
  int? localtimeEpoch;
  String? localtime;

  Location({
    this.name,
    this.region,
    this.country,
    this.lat,
    this.lon,
    this.tzId,
    this.localtimeEpoch,
    this.localtime,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    name: json['name'],
    region: json['region'],
    country: json['country'],
    lat: (json['lat'] as num?)?.toDouble(),
    lon: (json['lon'] as num?)?.toDouble(),
    tzId: json['tz_id'],
    localtimeEpoch: json['localtime_epoch'],
    localtime: json['localtime'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'region': region,
    'country': country,
    'lat': lat,
    'lon': lon,
    'tz_id': tzId,
    'localtime_epoch': localtimeEpoch,
    'localtime': localtime,
  };
}

// Class for current weather details
class Current {
  String? lastUpdated;
  double? tempC;
  int? humidity;

  Current({
    this.lastUpdated,
    this.tempC,
    this.humidity,
  });

  factory Current.fromJson(Map<String, dynamic> json) => Current(
    lastUpdated: json['last_updated'],
    tempC: (json['temp_c'] as num?)?.toDouble(),
    humidity: json['humidity'],
  );

  Map<String, dynamic> toJson() => {
    'last_updated': lastUpdated,
    'temp_c': tempC,
    'humidity': humidity,
  };
}

// Class for forecast details
class Forecast {
  List<Forecastday>? forecastday;

  Forecast({this.forecastday});

  factory Forecast.fromJson(Map<String, dynamic> json) => Forecast(
    forecastday: (json['forecastday'] as List<dynamic>?)
        ?.map((item) => Forecastday.fromJson(item))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'forecastday': forecastday?.map((item) => item.toJson()).toList(),
  };
}

// Class for forecast day details
class Forecastday {
  String? date;
  Day? day;

  Forecastday({this.date, this.day});

  factory Forecastday.fromJson(Map<String, dynamic> json) => Forecastday(
    date: json['date'],
    day: json['day'] != null ? Day.fromJson(json['day']) : null,
  );

  Map<String, dynamic> toJson() => {
    'date': date,
    'day': day?.toJson(),
  };
}

// Class for daily weather details
class Day {
  double? maxtempC;
  double? mintempC;

  Day({this.maxtempC, this.mintempC});

  factory Day.fromJson(Map<String, dynamic> json) => Day(
    maxtempC: (json['maxtemp_c'] as num?)?.toDouble(),
    mintempC: (json['mintemp_c'] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'maxtemp_c': maxtempC,
    'mintemp_c': mintempC,
  };
}

