# weather_app

Packages: geolocator, weather, intl, flutter_bloc, equatable

## Presentation

![Application](https://github.com/BUYZQ/Weather-App/blob/main/assets/images/presentation.png)

## main.dart

```dart
void main() {
  // setting the background color of the system bottom navigation
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const WeatherApp());
}
```

## weather_app.dart

```dart
class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      // checking whether the user's location has been found
      home: FutureBuilder(
        future: _determinePosition(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final Position position = snapshot.data!;
            return BlocProvider<WeatherBloc>(
              create: (context) => WeatherBloc()..add(FetchWeather(position: position)),
              child: const HomeScreen(),
            );
          } else {
            return const Scaffold(
              backgroundColor: Colors.black,
              body: BackgroundGradient(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 6),
                      Text(
                        'Загрузка данных',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
```

## Screen

```dart
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
```

## BLoC

```dart
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
```