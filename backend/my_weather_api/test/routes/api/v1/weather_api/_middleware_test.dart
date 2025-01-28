import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_weather_api/src/weather_api/datasources/remote_data_sources/weather_api.dart';
import 'package:my_weather_api/src/weather_api/repositories/weather_api_repository.dart';
import 'package:test/test.dart';

import '../../../../../routes/api/v1/weather_api/_middleware.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class MockWeatherApi extends Mock implements WeatherApi {}

void main() {
  late MockWeatherApi mockWeatherApi;

  setUp(() {
    mockWeatherApi = MockWeatherApi();
  });

  group('middleware', () {
    test('provides WeatherApiRepository and WeatherApi instances', () async {
      //arrange
      late WeatherApiRepository weatherApiRepository;
      late WeatherApi weatherApi;
      final weatherApiRepositoryImpl =
          WeatherApiRepositoryImpl(weatherApi: mockWeatherApi);

      final handler = middleware((context) {
        when(() => context.read<WeatherApiRepository>())
            .thenReturn(weatherApiRepositoryImpl);
        when(() => context.read<WeatherApi>()).thenReturn(mockWeatherApi);

        weatherApiRepository = context.read<WeatherApiRepository>();
        weatherApi = context.read<WeatherApi>();

        return Response.json();
      });

      final request = Request.get(Uri.parse('http://localhost/'));
      final context = _MockRequestContext();
      when(() => context.request).thenReturn(request);

      when(() => context.provide<WeatherApiRepository>(any()))
          .thenReturn(context);
      when(() => context.provide<WeatherApi>(any())).thenReturn(context);

      //act
      await handler(context);

      //assert
      expect(weatherApiRepository, isA<WeatherApiRepository>());
      expect(weatherApi, isA<WeatherApi>());

      verify(() => context.read<WeatherApiRepository>()).called(1);
      verify(() => context.read<WeatherApi>()).called(1);

      verify(() => context.provide<WeatherApiRepository>(captureAny()))
          .captured
          .single as WeatherApiRepository Function();

      verify(() => context.provide<WeatherApi>(captureAny())).captured.single
          as WeatherApi Function();
    });
  });
}
