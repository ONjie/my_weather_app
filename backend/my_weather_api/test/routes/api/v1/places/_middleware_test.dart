import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_weather_api/src/places_api/data_sources/remote_data_source/places_api.dart';
import 'package:my_weather_api/src/places_api/repositories/places_api_repository.dart';
import 'package:test/test.dart';

import '../../../../../routes/api/v1/places_api/_middleware.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class MockPlacesApi extends Mock implements PlacesApi {}

void main() {
  late MockPlacesApi mockPlacesApi;

  setUp(() {
    mockPlacesApi = MockPlacesApi();
  });

  test('should provide both PlacesApi and PlacesApiRepository instances',
      () async {
    //arrange
    late PlacesApiRepository placesApiRepository;
    late PlacesApi placesApi;

    final placesApiRepositoryImpl = PlacesApiRepositoryImpl(
      placesApi: mockPlacesApi,
    );

    final handler = middleware((context) {
      when(() => context.read<PlacesApiRepository>())
          .thenReturn(placesApiRepositoryImpl);
      when(() => context.read<PlacesApi>()).thenReturn(mockPlacesApi);

      placesApiRepository = context.read<PlacesApiRepository>();
      placesApi = context.read<PlacesApi>();

      return Response.json();
    });

    final request = Request.get(Uri.parse('http://localhost/'));
    final context = _MockRequestContext();

    when(() => context.request).thenReturn(request);

    when(() => context.provide<PlacesApiRepository>(any())).thenReturn(context);
    when(() => context.provide<PlacesApi>(any())).thenReturn(context);

    //act
    await handler(context);

    expect(placesApiRepository, isA<PlacesApiRepository>());
    expect(placesApi, isA<PlacesApi>());
    verify(() => context.read<PlacesApiRepository>()).called(1);
    verify(() => context.read<PlacesApi>()).called(1);

    verify(() => context.provide<PlacesApiRepository>(captureAny()))
        .captured
        .single as PlacesApiRepository Function();

    verify(() => context.provide<PlacesApi>(captureAny()))
        .captured
        .single as PlacesApi Function();
  });
}
