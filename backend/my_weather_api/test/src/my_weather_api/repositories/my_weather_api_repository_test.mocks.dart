// Mocks generated by Mockito 5.4.5 from annotations
// in my_weather_api/test/src/my_weather_api/repositories/my_weather_api_repository_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:mockito/mockito.dart' as _i1;
import 'package:my_weather_api/src/my_weather_api/data_sources/remote_data_source/open_weather_map_api.dart'
    as _i4;
import 'package:my_weather_api/src/my_weather_api/models/location_current_weather_model.dart'
    as _i3;
import 'package:my_weather_api/src/my_weather_api/models/weather_forecast_model.dart'
    as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeWeatherForecastModel_0 extends _i1.SmartFake
    implements _i2.WeatherForecastModel {
  _FakeWeatherForecastModel_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLocationCurrentWeatherModel_1 extends _i1.SmartFake
    implements _i3.LocationCurrentWeatherModel {
  _FakeLocationCurrentWeatherModel_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [OpenWeatherMapApi].
///
/// See the documentation for Mockito's code generation for more information.
class MockOpenWeatherMapApi extends _i1.Mock implements _i4.OpenWeatherMapApi {
  @override
  _i5.Future<_i2.WeatherForecastModel> fetchWeatherForecast({
    required double? lat,
    required double? lon,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchWeatherForecast,
          [],
          {
            #lat: lat,
            #lon: lon,
          },
        ),
        returnValue: _i5.Future<_i2.WeatherForecastModel>.value(
            _FakeWeatherForecastModel_0(
          this,
          Invocation.method(
            #fetchWeatherForecast,
            [],
            {
              #lat: lat,
              #lon: lon,
            },
          ),
        )),
        returnValueForMissingStub: _i5.Future<_i2.WeatherForecastModel>.value(
            _FakeWeatherForecastModel_0(
          this,
          Invocation.method(
            #fetchWeatherForecast,
            [],
            {
              #lat: lat,
              #lon: lon,
            },
          ),
        )),
      ) as _i5.Future<_i2.WeatherForecastModel>);

  @override
  _i5.Future<_i3.LocationCurrentWeatherModel> fetchLocationCurrentWeather({
    required double? lat,
    required double? lon,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchLocationCurrentWeather,
          [],
          {
            #lat: lat,
            #lon: lon,
          },
        ),
        returnValue: _i5.Future<_i3.LocationCurrentWeatherModel>.value(
            _FakeLocationCurrentWeatherModel_1(
          this,
          Invocation.method(
            #fetchLocationCurrentWeather,
            [],
            {
              #lat: lat,
              #lon: lon,
            },
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.LocationCurrentWeatherModel>.value(
                _FakeLocationCurrentWeatherModel_1(
          this,
          Invocation.method(
            #fetchLocationCurrentWeather,
            [],
            {
              #lat: lat,
              #lon: lon,
            },
          ),
        )),
      ) as _i5.Future<_i3.LocationCurrentWeatherModel>);
}
