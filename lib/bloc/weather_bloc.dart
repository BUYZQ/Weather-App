import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/constants/constants.dart';

part 'weather_event.dart';
part 'weather_state.dart';


class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(InitialState()) {
    on<FetchWeather>(_fetchWeather);
  }

  // init current weather
  void _fetchWeather(FetchWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      // init api https://home.openweathermap.org
      WeatherFactory wf = WeatherFactory(API_KEY, language: Language.RUSSIAN);

      // current user location
      Position position = event.position;

      // get weather in user location
      Weather weather = await wf.currentWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      emit(WeatherLoaded(weather));
    } catch(e) {
      emit(WeatherFailed());
    }
  }
}