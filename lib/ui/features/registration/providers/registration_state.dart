import '../../../../data/services/geocoding_service.dart';
import '../models/registration_draft.dart';

class RegistrationState {
  static const int totalSteps = 4;

  final RegistrationDraft draft;
  final int step;
  final List<AddressSuggestion> suggestions;
  final bool isSearching;
  final bool isLookingUpPostcode;
  final PostcodeLookupStatus? postcodeStatus;
  final String? errorMessage;
  final bool isSubmitting;
  final bool submitted;

  const RegistrationState({
    this.draft = const RegistrationDraft(),
    this.step = 1,
    this.suggestions = const [],
    this.isSearching = false,
    this.isLookingUpPostcode = false,
    this.postcodeStatus,
    this.errorMessage,
    this.isSubmitting = false,
    this.submitted = false,
  });

  RegistrationState copyWith({
    RegistrationDraft? draft,
    int? step,
    List<AddressSuggestion>? suggestions,
    bool? isSearching,
    bool? isLookingUpPostcode,
    PostcodeLookupStatus? postcodeStatus,
    String? errorMessage,
    bool? isSubmitting,
    bool? submitted,
    bool clearSuggestions = false,
    bool clearPostcodeStatus = false,
    bool clearError = false,
    bool clearSubmitted = false,
  }) {
    return RegistrationState(
      draft: draft ?? this.draft,
      step: step ?? this.step,
      suggestions:
          clearSuggestions ? const [] : (suggestions ?? this.suggestions),
      isSearching: isSearching ?? this.isSearching,
      isLookingUpPostcode:
          isLookingUpPostcode ?? this.isLookingUpPostcode,
      postcodeStatus: clearPostcodeStatus
          ? null
          : (postcodeStatus ?? this.postcodeStatus),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitted: clearSubmitted ? false : (submitted ?? this.submitted),
    );
  }
}
