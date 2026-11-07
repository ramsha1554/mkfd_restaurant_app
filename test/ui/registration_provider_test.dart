import 'package:flutter_test/flutter_test.dart';
import 'package:mk_food_restaurant/core/error/app_error.dart';
import 'package:mk_food_restaurant/data/models/restaurant.dart';
import 'package:mk_food_restaurant/data/repositories/restaurant_repository.dart';
import 'package:mk_food_restaurant/data/services/geocoding_service.dart';
import 'package:mk_food_restaurant/domain/models/restaurant_registration.dart';
import 'package:mk_food_restaurant/ui/features/registration/providers/registration_provider.dart';

const _suggestion = AddressSuggestion(
  label: '14 Silbury Boulevard, Milton Keynes, MK9 3QA, United Kingdom',
  street: '14 Silbury Boulevard',
  city: 'Milton Keynes',
  postcode: 'MK9 3QA',
  latitude: 52.0406,
  longitude: -0.7594,
);

class _FakeGeocodingService implements GeocodingService {
  List<AddressSuggestion> searchResults = const [_suggestion];
  PostcodeLookupResult postcodeResult = const PostcodeLookupResult(
    status: PostcodeLookupStatus.success,
    postcode: 'MK9 3QA',
    city: 'Milton Keynes',
    country: 'England',
    latitude: 52.0406,
    longitude: -0.7594,
  );
  int searchCalls = 0;
  int postcodeCalls = 0;

  @override
  Future<List<AddressSuggestion>> searchAddresses(String query) async {
    searchCalls++;
    return searchResults;
  }

  @override
  Future<AddressSuggestion?> reverseAddress(
    double latitude,
    double longitude,
  ) async {
    return _suggestion;
  }

  @override
  Future<PostcodeLookupResult> lookupPostcode(String postcode) async {
    postcodeCalls++;
    return postcodeResult;
  }
}

class _FakeRestaurantRepository implements RestaurantRepository {
  RestaurantRegistrationDraft? created;
  Object? error;

  @override
  Future<RestaurantModel?> createRestaurant(
    RestaurantRegistrationDraft draft,
  ) async {
    if (error != null) throw error!;
    created = draft;
    return null;
  }

  @override
  Future<RestaurantModel?> getMyRestaurant() async => null;

  @override
  Future<RestaurantModel?> updateStatus(
    String id, {
    bool? isOpen,
    bool? isBusy,
  }) async {
    return null;
  }
}

void main() {
  late _FakeGeocodingService geocoding;
  late _FakeRestaurantRepository repository;
  late RegistrationNotifier notifier;

  setUp(() {
    geocoding = _FakeGeocodingService();
    repository = _FakeRestaurantRepository();
    notifier = RegistrationNotifier(geocoding, repository);
  });

  void fillValidDraft() {
    notifier.setName('Spice Garden');
    notifier.setPhone('+44 7123 456789');
    notifier.setEmail('hello@spicegarden.co.uk');
    notifier.addCuisine('Indian');
    notifier.setStreet('14 Silbury Boulevard');
    notifier.setCity('Milton Keynes');
    notifier.setPostcode('MK9 3QA');
    notifier.setCoordinates(52.0406, -0.7594);
    notifier.setMinimumOrder(10);
    notifier.setPreparationTime(30);
  }

  test('starts on step one with the registration defaults', () {
    expect(notifier.state.step, 1);
    expect(notifier.state.draft.city, 'Milton Keynes');
    expect(notifier.state.draft.minimumOrder, 0);
    expect(notifier.state.draft.preparationTime, 30);
    expect(notifier.state.draft.hasCoordinates, isFalse);
  });

  test('adds cuisines case-insensitively and removes them', () {
    notifier.addCuisine('Indian');
    notifier.addCuisine('indian');
    notifier.addCuisine('Curry');

    expect(notifier.state.draft.cuisines, ['Indian', 'Curry']);

    notifier.removeCuisine('Indian');
    expect(notifier.state.draft.cuisines, ['Curry']);
  });

  test('does not search until the query has three characters', () async {
    await notifier.searchAddresses('ab');

    expect(geocoding.searchCalls, 0);
    expect(notifier.state.suggestions, isEmpty);

    await notifier.searchAddresses('Sil');

    expect(geocoding.searchCalls, 1);
    expect(notifier.state.suggestions, hasLength(1));
    expect(notifier.state.isSearching, isFalse);
  });

  test('selects an address into the draft and clears suggestions', () async {
    await notifier.searchAddresses('Sil');
    notifier.selectAddress(_suggestion);

    expect(notifier.state.draft.street, '14 Silbury Boulevard');
    expect(notifier.state.draft.city, 'Milton Keynes');
    expect(notifier.state.draft.postcode, 'MK9 3QA');
    expect(notifier.state.draft.latitude, 52.0406);
    expect(notifier.state.draft.longitude, -0.7594);
    expect(notifier.state.suggestions, isEmpty);
  });

  test('rejects a malformed postcode without calling the service', () async {
    final result = await notifier.lookupPostcode('MK9');

    expect(result?.status, PostcodeLookupStatus.invalidFormat);
    expect(geocoding.postcodeCalls, 0);
    expect(notifier.state.postcodeStatus, PostcodeLookupStatus.invalidFormat);
  });

  test('fills city and coordinates from a successful postcode lookup', () async {
    notifier.setPostcode('mk93qa');

    final result = await notifier.lookupPostcode('mk93qa');

    expect(result?.status, PostcodeLookupStatus.success);
    expect(geocoding.postcodeCalls, 1);
    expect(notifier.state.draft.city, 'Milton Keynes');
    expect(notifier.state.draft.postcode, 'MK9 3QA');
    expect(notifier.state.draft.latitude, 52.0406);
    expect(notifier.state.draft.longitude, -0.7594);
    expect(notifier.state.postcodeStatus, PostcodeLookupStatus.success);
  });

  test('keeps a failed postcode off the draft', () async {
    geocoding.postcodeResult = const PostcodeLookupResult(
      status: PostcodeLookupStatus.notFound,
    );

    final result = await notifier.lookupPostcode('MK9 3QA');

    expect(result?.status, PostcodeLookupStatus.notFound);
    expect(notifier.state.postcodeStatus, PostcodeLookupStatus.notFound);
    expect(notifier.state.draft.hasCoordinates, isFalse);
  });

  test('submit blocks on the first invalid step', () async {
    final error = await notifier.submit();

    expect(error, 'Enter your restaurant name.');
    expect(notifier.state.step, 1);
    expect(repository.created, isNull);
  });

  test('submit moves to the failing step', () async {
    notifier.setName('Spice Garden');
    notifier.setPhone('+44 7123 456789');
    notifier.setEmail('hello@spicegarden.co.uk');
    notifier.addCuisine('Indian');

    final error = await notifier.submit();

    expect(error, 'Enter your street address.');
    expect(notifier.state.step, 2);
    expect(repository.created, isNull);
  });

  test('submits normalised data and marks the flow submitted', () async {
    fillValidDraft();

    final error = await notifier.submit();

    expect(error, isNull);
    expect(notifier.state.submitted, isTrue);
    expect(notifier.state.isSubmitting, isFalse);

    final created = repository.created!;
    expect(created.phone, '+447123456789');
    expect(created.email, 'hello@spicegarden.co.uk');
    expect(created.postcode, 'MK9 3QA');
    expect(created.cuisineTypes, ['Indian']);
    expect(created.latitude, 52.0406);
    expect(created.longitude, -0.7594);
  });

  test('returns the API message when submission fails', () async {
    fillValidDraft();
    repository.error = const NetworkException('offline');

    final error = await notifier.submit();

    expect(error, contains('No internet connection'));
    expect(notifier.state.submitted, isFalse);
    expect(notifier.state.isSubmitting, isFalse);
  });

  test('steps clamp at one and four', () {
    notifier.previousStep();
    expect(notifier.state.step, 1);

    notifier.goToStep(9);
    expect(notifier.state.step, 4);
  });
}
