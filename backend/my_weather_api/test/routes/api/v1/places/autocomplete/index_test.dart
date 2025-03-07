import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:either_dart/either.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_weather_api/core/failures/failures.dart';
import 'package:my_weather_api/src/places_api/models/place_model.dart';
import 'package:my_weather_api/src/places_api/repositories/places_api_repository.dart';
import 'package:test/test.dart';

import '../../../../../../routes/api/v1/places_api/autocomplete/index.dart'
    as route;

class _MockRequestContext extends Mock implements RequestContext {}

class MockRequest extends Mock implements Request {}

class MockPlacesApiRepository extends Mock implements PlacesApiRepository {}

void main() {
  late _MockRequestContext mockRequestContext;
  late MockRequest mockRequest;
  late MockPlacesApiRepository mockPlacesApiRepository;

  setUp(() {
    mockRequestContext = _MockRequestContext();
    mockRequest = MockRequest();
    mockPlacesApiRepository = MockPlacesApiRepository();

    when(() => mockRequestContext.request).thenReturn(mockRequest);
    when(() => mockRequestContext.read<PlacesApiRepository>()).thenReturn(
      mockPlacesApiRepository,
    );
  });

  group('GET /', () {
    const tLocationName = 'Banjul';

    const tProperties = Properties(
      locationName: 'Banjul',
      country: 'The Gambia',
      formatted: 'Banjul, The Gambia',
      lon: -16.575646,
      lat: 13.45535,
    );

    const tFeature = Feature(properties: tProperties);

    const tPlaceModel = PlaceModel(features: [tFeature]);

    test(
        'should return HttpStatus.badRequest and an error message when locationName is not provided',
        () async {
      //arrange
      when(
        () => mockRequest.method,
      ).thenReturn(HttpMethod.get);
      when(
        () => mockRequest.uri,
      ).thenReturn(
        Uri(
          queryParameters: {
            'location_name': '',
          },
        ),
      );

      //act
      final response = await route.onRequest(mockRequestContext);

      final body = jsonDecode(await response.body()) as Map<String, dynamic>;

      //assert
      expect(response.statusCode, equals(HttpStatus.badRequest));
      expect(body['error'], equals('location name is required'));
      verify(() => mockRequest.method).called(1);
      verify(() => mockRequest.uri).called(1);
      verifyNoMoreInteractions(mockRequest);
    });

    test(
        'should return HttpStatus.notFound and an error message when fetchPlaceSuggestions is unsuccessful',
        () async {
      //arrange
      when(
        () => mockRequest.method,
      ).thenReturn(HttpMethod.get);
      when(() => mockRequest.uri).thenReturn(
        Uri(
          queryParameters: {
            'location_name': tLocationName,
          },
        ),
      );

      when(
        () => mockPlacesApiRepository.fetchPlaceSuggestions(
          locationName: any(named: 'locationName'),
        ),
      ).thenAnswer(
        (_) async => const Left(
          PlacesApiFailure(
            message: 'Not found',
          ),
        ),
      );

      //act
      final response = await route.onRequest(mockRequestContext);

      final body = jsonDecode(await response.body()) as Map<String, dynamic>;

      //assert
      expect(response.statusCode, equals(HttpStatus.notFound));
      expect(body['error'], equals('Not found'));
      verify(() => mockRequest.method).called(1);
      verify(() => mockRequest.uri).called(1);
      verify(
        () => mockPlacesApiRepository.fetchPlaceSuggestions(
          locationName: any(named: 'locationName'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRequest);
      verifyNoMoreInteractions(mockPlacesApiRepository);
    });



    test(
        'should return HttpStatus.ok and PlaceModel.toJson when fetchPlaceSuggestions is successful',
        () async {
      //arrange
      when(
        () => mockRequest.method,
      ).thenReturn(HttpMethod.get);
      when(() => mockRequest.uri).thenReturn(
        Uri(
          queryParameters: {
            'location_name': tLocationName,
          },
        ),
      );

      when(
        () => mockPlacesApiRepository.fetchPlaceSuggestions(
          locationName: any(named: 'locationName'),
        ),
      ).thenAnswer(
        (_) async => const Right(tPlaceModel),
      );

      //act
      final response = await route.onRequest(mockRequestContext);

      final body = jsonDecode(await response.body()) as Map<String, dynamic>;

      //assert
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(body, equals(tPlaceModel.toJson()));
      verify(() => mockRequest.method).called(1);
      verify(() => mockRequest.uri).called(1);
      verify(
        () => mockPlacesApiRepository.fetchPlaceSuggestions(
          locationName: any(named: 'locationName'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRequest);
      verifyNoMoreInteractions(mockPlacesApiRepository);
    });
  });
}
