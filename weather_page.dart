// weather_page.dart

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mausam/service/weather_service.dart';
import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('71fac58ed154717d3a1eefc9da535af6');
  Weather? _weather;

  _fetchWeather() async {
    //get the current city
    String cityName = await _weatherService.getCurrentCity();
    print('Fetching weather for city: $cityName');
    //get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    //any error
    catch (e) {
      print('Error fetching weather: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _weather?.cityName ?? "Loading city...",
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                _getCurrentDayAndTime(),
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
              Lottie.asset(
                getWeatherAnimation(_weather?.mainCondition),
              ),
              Text(
                '${_weather?.temperature?.round() ?? 0}°C',
                style: TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                _getGreetingMessage(),
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCurrentDayAndTime() {
    final now = DateTime.now();
    final dayOfWeek = _getDayOfWeek(now.weekday);
    final formattedTime = "${now.hour}:${now.minute.toString().padLeft(2, '0')} ${_getPeriodOfDay(now.hour)}";
    return "$dayOfWeek, $formattedTime";
  }

  String _getDayOfWeek(int dayIndex) {
    final daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
    return daysOfWeek[dayIndex - 1];
  }

  String _getPeriodOfDay(int hour) {
    if (hour >= 4 && hour < 12) {
      return "AM";
    } else {
      return "PM";
    }
  }

  String _getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else if (hour >= 17 && hour < 20) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null)
      return 'asset/sunny.json'; //default sunny
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'asset/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'asset/rain.json';
      case 'thunderstrom':
        return 'asset/thunder.json';
      case 'clear':
        return 'asset/sunny.json';
      default:
        return 'asset/sunny.json';
    }
  }
}
