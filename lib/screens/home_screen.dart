import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/bloc/weather_bloc.dart';
import 'package:weather_app/widgets/background_gradient.dart';
import 'package:weather_app/widgets/weather_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
      ),
      body: BackgroundGradient(
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if(state is WeatherLoaded) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Name city
                    Text(
                      '📍 ${state.weather.areaName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    // Weather image
                    getWeatherIcon(state.weather.weatherConditionCode!),

                    // Temperature
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${state.weather.temperature!.celsius!.round()}°C',
                        style: const TextStyle(
                          fontSize: 55,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Weather title (clear, cloud, rain)
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        state.weather.weatherMain!.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // Date time
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        DateFormat('EEEE dd •').add_jm().format(state.weather.date!),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Tiles
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WeatherTile(
                          imagePath: 'assets/images/hot.png',
                          title: 'Sunrice',
                          subtitle: state.weather.sunrise!,
                        ),
                        WeatherTile(
                          imagePath: 'assets/images/moon.png',
                          title: 'Sunset',
                          subtitle: state.weather.sunset!,
                        ),
                      ],
                    ),

                    // Divider
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),

                    // Tiles
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WeatherTile(
                          imagePath: 'assets/images/max_temp.png',
                          title: 'Temp Max',
                          subtitle: '${state.weather.tempMax!.celsius!.round()}°C',
                        ),
                        WeatherTile(
                          imagePath: 'assets/images/min_temp.png',
                          title: 'Temp Min',
                          subtitle: '${state.weather.tempMin!.celsius!.round()}°C',
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  // setting the desired image
  Widget getWeatherIcon(int code) {
    switch(code) {
      case >= 200 && <= 232:
        return Image.asset('assets/images/thunderstorm.png');
      case >= 300 && <= 321:
        return Image.asset('assets/images/drizzle.png');
      case >= 500 && <= 531:
        return Image.asset('assets/images/rain.png');
      case >= 600 && <= 622:
        return Image.asset('assets/images/snow.png');
      case >= 701 && <= 781:
        return Image.asset('assets/images/atmosphere.png');
      case >= 800:
        return Image.asset('assets/images/clear.png');
      case >= 801:
        return Image.asset('assets/images/cloud_sun.png');
      case >= 802 && <= 804:
        return Image.asset('assets/images/cloud.png');
      default:
        return Image.asset('assets/images/cloud.png');
    }
  }
}
