import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_weather_api/src/weather_api/repositories/weather_api_repository.dart';

Future<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.post => _onPost(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _onPost(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;

  final lat = body['lat'] as double;
  final long = body['long'] as double;

  final weatherApiRepository = context.read<WeatherApiRepository>();

  final weatherDataOrFailure = await weatherApiRepository.getWeatherData(
    lat: lat,
    long: long,
  );

  return weatherDataOrFailure.fold((failure) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {'error': failure.message},
    );
  }, (weatherData) {
    return Response.json(
      body: {
        'forecast': {
          'forecastday': [
            {
              'date': weatherData.forecast.forecastday[0].date,
              'date_epoch': weatherData.forecast.forecastday[0].dateEpoch,
              'day': {
                'maxtemp_c': weatherData.forecast.forecastday[0].day.maxtempC,
                'mintemp_c': weatherData.forecast.forecastday[0].day.mintempC,
                'condition': {
                  'text':
                      weatherData.forecast.forecastday[0].day.condition.text,
                  'icon':
                      weatherData.forecast.forecastday[0].day.condition.icon,
                },
              },
              'astro': {
                'sunrise': weatherData.forecast.forecastday[0].astro.sunrise,
                'sunset': weatherData.forecast.forecastday[0].astro.sunset,
                'moon_phase':
                    weatherData.forecast.forecastday[0].astro.moonphase,
              },
              'hour': [
                {
                  'time_epoch':
                      weatherData.forecast.forecastday[0].hour[0].timeEpoch,
                  'time': weatherData.forecast.forecastday[0].hour[0].time,
                  'temp_c': weatherData.forecast.forecastday[0].hour[0].tempC,
                  'condition': {
                    'text': weatherData
                        .forecast.forecastday[0].hour[0].condition.text,
                    'icon': weatherData
                        .forecast.forecastday[0].hour[0].condition.icon,
                  },
                  'humidity':
                      weatherData.forecast.forecastday[0].hour[0].humidity,
                }
              ],
            }
          ],
        },
      },
    );
  });
}
