import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_weather_api/src/my_weather_api/data_sources/remote_data_source/open_weather_map_api.dart';
import 'package:my_weather_api/src/my_weather_api/repositories/my_weather_api_repository.dart';
import 'package:test/test.dart';

import '../../../../../routes/api/v1/my_weather_api/_middleware.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class MockOpenWeatherMapApi extends Mock implements OpenWeatherMapApi {}

void main() {
  late MockOpenWeatherMapApi mockOpenWeatherMapApi;

  setUp(() {
    mockOpenWeatherMapApi = MockOpenWeatherMapApi();
  });

  test(
      'should provide both MyWeatherApiRepository and OpenWeatherMapApi instances',
      () async {
    //arrange
    late MyWeatherApiRepository myWeatherApiRepository;
    late OpenWeatherMapApi openWeatherMapApi;
    final myWeatherApiRepositoryImpl = MyWeatherApiRepositoryImpl(
      openWeatherMapApi: mockOpenWeatherMapApi,
    );

    final handler = middleware((context) {
      when(() => context.read<MyWeatherApiRepository>())
          .thenReturn(myWeatherApiRepositoryImpl);
      when(() => context.read<OpenWeatherMapApi>())
          .thenReturn(mockOpenWeatherMapApi);

      myWeatherApiRepository = context.read<MyWeatherApiRepository>();
      openWeatherMapApi = context.read<OpenWeatherMapApi>();

      return Response.json();
    });

    final request = Request.get(Uri.parse('http://localhost/'));
    final context = _MockRequestContext();
    when(() => context.request).thenReturn(request);

    when(() => context.provide<MyWeatherApiRepository>(any()))
        .thenReturn(context);
    when(() => context.provide<OpenWeatherMapApi>(any())).thenReturn(context);

    //act
    await handler(context);

    //assert
    expect(myWeatherApiRepository, isA<MyWeatherApiRepository>());
    expect(openWeatherMapApi, isA<OpenWeatherMapApi>());

    verify(() => context.read<MyWeatherApiRepository>()).called(1);
    verify(() => context.read<OpenWeatherMapApi>()).called(1);

    verify(() => context.provide<MyWeatherApiRepository>(captureAny()))
        .captured
        .single as MyWeatherApiRepository Function();

    verify(() => context.provide<OpenWeatherMapApi>(captureAny()))
        .captured
        .single as OpenWeatherMapApi Function();
  });
}
