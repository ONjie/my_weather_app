import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/failures/failures.dart';
import 'package:weather_app/features/weather/domain/entities/weather_forecast_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/use_cases/fetch_weather_forecast_data.dart';
import 'fetch_weather_forecast_test.mocks.dart';

@GenerateNiceMocks([MockSpec<WeatherRepository>()])
void main() {
  late FetchWeatherForecast fetchWeatherForecast;
  late MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    fetchWeatherForecast =
        FetchWeatherForecast(weatherRepository: mockWeatherRepository);
  });

 const tTemp = TempEntity(
      maxTemp: 23.06,
      minTemp: 19.15,
    );

    const tWeather = WeatherEntity(
      description: 'clear sky',
      icon: '01n',
    );

    const tDaily = DailyEntity(
      dateTimestamp: 1739883600,
      sunriseTimestamp: 1739863686,
      sunsetTimestamp: 1739905959,
      temp: tTemp,
      weather: [tWeather],
    );

    const tHourly = HourlyEntity(
      dateTimestamp: 1739919600,
      temp: 21.95,
      weather: [tWeather],
      humidity: 66,
    );

    const tWeatherForecast = WeatherForecastEntity(
      hourly: [tHourly, tHourly],
      daily: [tDaily, tDaily],
    );

  provideDummy<Either<Failure, WeatherForecastEntity>>(
      const Right(tWeatherForecast));

  test('should return Right(WeatherForecastEntity) from WeatherDataRepository',
      () async {
    //arrange
    when(mockWeatherRepository.fetchWeatherForecast())
        .thenAnswer((_) async => const Right(tWeatherForecast));

    //act
    final result = await fetchWeatherForecast.execute();

    //assert
    expect(result, const Right(tWeatherForecast));
    verify(mockWeatherRepository.fetchWeatherForecast());
    verifyNoMoreInteractions(mockWeatherRepository);
  });
}
