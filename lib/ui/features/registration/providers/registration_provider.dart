import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/error/app_error.dart';
import '../../../../core/utils/app_log.dart';
import '../../../../core/utils/uk_postcode.dart';
import '../../../../data/repositories/restaurant_repository.dart';
import '../../../../data/services/geocoding_service.dart';
import '../models/registration_draft.dart';
import '../utils/registration_validation.dart';
import 'registration_state.dart';

final registrationProvider =
    StateNotifierProvider<RegistrationNotifier, RegistrationState>((ref) {
  return RegistrationNotifier(
    locator<GeocodingService>(),
    locator<RestaurantRepository>(),
  );
});

class RegistrationNotifier extends StateNotifier<RegistrationState> {
  final GeocodingService _geocoding;
  final RestaurantRepository _repository;

  int _searchSequence = 0;
  int _postcodeSequence = 0;

  RegistrationNotifier(this._geocoding, this._repository)
      : super(const RegistrationState());

  void setName(String value) => _updateDraft((d) => d.copyWith(name: value));

  void setPhone(String value) => _updateDraft((d) => d.copyWith(phone: value));

  void setEmail(String value) => _updateDraft((d) => d.copyWith(email: value));

  void setDescription(String value) =>
      _updateDraft((d) => d.copyWith(description: value));

  void addCuisine(String value) {
    final cuisine = value.trim();
    if (cuisine.isEmpty) return;
    if (state.draft.cuisines
        .any((c) => c.toLowerCase() == cuisine.toLowerCase())) {
      return;
    }
    _updateDraft(
      (d) => d.copyWith(cuisines: [...d.cuisines, cuisine]),
    );
  }

  void removeCuisine(String value) {
    _updateDraft(
      (d) => d.copyWith(
        cuisines: d.cuisines.where((c) => c != value).toList(),
      ),
    );
  }

  void setStreet(String value) =>
      _updateDraft((d) => d.copyWith(street: value));

  void setCity(String value) => _updateDraft((d) => d.copyWith(city: value));

  void setPostcode(String value) {
    state = state.copyWith(
      draft: state.draft.copyWith(postcode: value),
      clearPostcodeStatus: true,
    );
  }

  void setCoordinates(double latitude, double longitude) {
    _updateDraft(
      (d) => d.copyWith(latitude: latitude, longitude: longitude),
    );
  }

  void selectAddress(AddressSuggestion suggestion) {
    state = state.copyWith(
      draft: state.draft.copyWith(
        street: suggestion.street ?? state.draft.street,
        city: suggestion.city ?? state.draft.city,
        postcode: suggestion.postcode ?? state.draft.postcode,
        latitude: suggestion.latitude,
        longitude: suggestion.longitude,
      ),
      clearSuggestions: true,
      clearPostcodeStatus: true,
    );
  }

  void setMinimumOrder(double value) =>
      _updateDraft((d) => d.copyWith(minimumOrder: value));

  void setPreparationTime(int value) {
    _updateDraft(
      (d) => d.copyWith(preparationTime: value.clamp(5, 180)),
    );
  }

  void goToStep(int step) {
    state = state.copyWith(step: step.clamp(1, RegistrationState.totalSteps));
  }

  void nextStep() => goToStep(state.step + 1);

  void previousStep() => goToStep(state.step - 1);

  void clearSuggestions() {
    if (state.suggestions.isNotEmpty || state.isSearching) {
      state = state.copyWith(clearSuggestions: true, isSearching: false);
    }
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(clearError: true);
    }
  }

  Future<void> searchAddresses(String query) async {
    final trimmed = query.trim();
    final sequence = ++_searchSequence;

    if (trimmed.length < 3) {
      state = state.copyWith(
        clearSuggestions: true,
        isSearching: false,
      );
      return;
    }

    state = state.copyWith(isSearching: true, clearError: true);
    try {
      final results = await _geocoding.searchAddresses(trimmed);
      if (!mounted || sequence != _searchSequence) return;
      state = state.copyWith(
        suggestions: results,
        isSearching: false,
      );
    } catch (e, s) {
      AppLog.e('GEO', 'searchAddresses', 'failed', e, s);
      if (!mounted || sequence != _searchSequence) return;
      state = state.copyWith(
        clearSuggestions: true,
        isSearching: false,
        errorMessage: AppError.message(e),
      );
    }
  }

  Future<PostcodeLookupResult?> lookupPostcode(String value) async {
    final trimmed = value.trim();
    final sequence = ++_postcodeSequence;

    if (trimmed.isEmpty) {
      state = state.copyWith(
        clearPostcodeStatus: true,
        isLookingUpPostcode: false,
      );
      return null;
    }

    if (!isValidUkPostcode(trimmed)) {
      final result = const PostcodeLookupResult(
        status: PostcodeLookupStatus.invalidFormat,
      );
      state = state.copyWith(
        postcodeStatus: result.status,
        isLookingUpPostcode: false,
      );
      return result;
    }

    state = state.copyWith(
      isLookingUpPostcode: true,
      clearPostcodeStatus: true,
    );
    final result = await _geocoding.lookupPostcode(trimmed);
    if (!mounted || sequence != _postcodeSequence) return result;

    if (result.isSuccess) {
      state = state.copyWith(
        draft: state.draft.copyWith(
          city: result.city ?? state.draft.city,
          postcode: result.postcode ?? normaliseUkPostcode(trimmed),
          latitude: result.latitude,
          longitude: result.longitude,
        ),
        postcodeStatus: result.status,
        isLookingUpPostcode: false,
      );
    } else {
      state = state.copyWith(
        postcodeStatus: result.status,
        isLookingUpPostcode: false,
      );
    }
    return result;
  }

  Future<AddressSuggestion?> describePoint(
    double latitude,
    double longitude,
  ) async {
    try {
      return await _geocoding.reverseAddress(latitude, longitude);
    } catch (e, s) {
      AppLog.e('GEO', 'describePoint', 'failed', e, s);
      return null;
    }
  }

  String? validateStepOne() {
    final draft = state.draft;
    return validateRestaurantName(draft.name) ??
        validatePhone(draft.phone) ??
        validateEmail(draft.email) ??
        validateCuisines(draft.cuisines);
  }

  String? validateStepTwo() {
    final draft = state.draft;
    return validateStreet(draft.street) ??
        validateCity(draft.city) ??
        validatePostcode(draft.postcode) ??
        validateCoordinates(draft.latitude, draft.longitude);
  }

  String? validateStepThree() {
    final draft = state.draft;
    return validateMinimumOrder(draft.minimumOrder) ??
        validatePreparationTime(draft.preparationTime);
  }

  /// Returns `null` on success, otherwise the message to surface.
  Future<String?> submit() async {
    if (state.isSubmitting) return null;

    for (final entry in {
      1: validateStepOne,
      2: validateStepTwo,
      3: validateStepThree,
    }.entries) {
      final message = entry.value();
      if (message != null) {
        state = state.copyWith(step: entry.key);
        return message;
      }
    }

    state = state.copyWith(isSubmitting: true);
    try {
      await _repository.createRestaurant(state.draft.toRequest());
      if (!mounted) return null;
      state = state.copyWith(
        isSubmitting: false,
        submitted: true,
        clearError: true,
      );
      return null;
    } catch (e, s) {
      AppLog.e('STORE', 'registration', 'submit failed', e, s);
      if (!mounted) return null;
      state = state.copyWith(isSubmitting: false);
      return AppError.message(e);
    }
  }

  void _updateDraft(RegistrationDraft Function(RegistrationDraft) change) {
    state = state.copyWith(draft: change(state.draft));
  }
}
