import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/animations/app_durations.dart';
import '../../../../core/utils/navigation.dart';
import '../../../../data/services/geocoding_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/app_text_field.dart';
import '../providers/registration_provider.dart';
import '../widgets/address_map_preview.dart';
import '../widgets/registration_footer.dart';
import 'location_map_view.dart';

class RegisterLocationStepView extends ConsumerStatefulWidget {
  const RegisterLocationStepView({super.key});

  @override
  ConsumerState<RegisterLocationStepView> createState() =>
      _RegisterLocationStepViewState();
}

class _RegisterLocationStepViewState
    extends ConsumerState<RegisterLocationStepView> {
  late final TextEditingController _searchController;
  late final TextEditingController _streetController;
  late final TextEditingController _cityController;
  late final TextEditingController _postcodeController;

  Timer? _searchTimer;
  Timer? _postcodeTimer;

  bool _streetError = false;
  bool _cityError = false;
  bool _postcodeError = false;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(registrationProvider).draft;
    _searchController = TextEditingController();
    _streetController = TextEditingController(text: draft.street);
    _cityController = TextEditingController(text: draft.city);
    _postcodeController = TextEditingController(text: draft.postcode);
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    _postcodeTimer?.cancel();
    _searchController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _postcodeController.dispose();
    super.dispose();
  }

  void _sync(TextEditingController controller, String value) {
    if (controller.text == value) return;
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  void _onSearchChanged(String value) {
    _searchTimer?.cancel();
    final notifier = ref.read(registrationProvider.notifier);
    if (value.trim().length < 3) {
      notifier.clearSuggestions();
      return;
    }
    _searchTimer = Timer(AppDurations.searchDebounce, () {
      notifier.searchAddresses(value);
    });
  }

  void _onPostcodeChanged(String value) {
    _postcodeTimer?.cancel();
    final notifier = ref.read(registrationProvider.notifier);
    notifier.setPostcode(value);
    if (_postcodeError) setState(() => _postcodeError = false);
    if (value.trim().isEmpty) return;
    _postcodeTimer = Timer(AppDurations.postcodeDebounce, () {
      notifier.lookupPostcode(value);
    });
  }

  void _selectSuggestion(AddressSuggestion suggestion) {
    ref.read(registrationProvider.notifier).selectAddress(suggestion);
    _searchController.clear();
    FocusScope.of(context).unfocus();
  }

  Future<void> _openMap() async {
    final draft = ref.read(registrationProvider).draft;
    final point = await Navigator.of(context).push<LatLng>(
      slideUpFadeRoute(
        LocationMapView(
          initialLatitude: draft.latitude,
          initialLongitude: draft.longitude,
        ),
      ),
    );
    if (point == null) return;
    ref
        .read(registrationProvider.notifier)
        .setCoordinates(point.latitude, point.longitude);
  }

  void _continue() {
    final notifier = ref.read(registrationProvider.notifier);
    final draft = ref.read(registrationProvider).draft;

    setState(() {
      _streetError = draft.street.trim().isEmpty;
      _cityError = draft.city.trim().isEmpty;
      _postcodeError = draft.postcode.trim().isEmpty;
    });

    final message = notifier.validateStepTwo();
    if (message != null) {
      AppSnackbar.showError(context, message);
      return;
    }
    notifier.nextStep();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(registrationProvider, (previous, next) {
      if (previous?.draft.street != next.draft.street) {
        _sync(_streetController, next.draft.street);
      }
      if (previous?.draft.city != next.draft.city) {
        _sync(_cityController, next.draft.city);
      }
      if (previous?.draft.postcode != next.draft.postcode) {
        _sync(_postcodeController, next.draft.postcode);
      }
    });

    final state = ref.watch(registrationProvider);
    final draft = state.draft;
    final query = _searchController.text.trim();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              0,
              AppSpacing.screenPadding,
              AppSpacing.xxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Where can customers find you?', style: AppTextStyles.h1),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Search your address and drop a pin on the exact entrance.',
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: AppSpacing.xl),
                AppTextField(
                  hintText: 'Search building, street or postcode',
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  prefixIcon: const Icon(Icons.search),
                  suffix: state.isSearching
                      ? const AppLoading(size: 16, strokeWidth: 2)
                      : null,
                  onChanged: _onSearchChanged,
                ),
                if (state.suggestions.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _SuggestionList(
                    suggestions: state.suggestions,
                    onSelected: _selectSuggestion,
                  ),
                ] else if (query.isNotEmpty && query.length < 3) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Type at least 3 characters to search.',
                    style: AppTextStyles.caption,
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Street address',
                  isRequired: true,
                  hintText: 'Building and street',
                  controller: _streetController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  hasError: _streetError,
                  onChanged: (value) {
                    ref.read(registrationProvider.notifier).setStreet(value);
                    if (_streetError) setState(() => _streetError = false);
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'City',
                        isRequired: true,
                        hintText: 'Milton Keynes',
                        controller: _cityController,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        hasError: _cityError,
                        onChanged: (value) {
                          ref
                              .read(registrationProvider.notifier)
                              .setCity(value);
                          if (_cityError) setState(() => _cityError = false);
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppTextField(
                        label: 'Postcode',
                        isRequired: true,
                        hintText: 'MK9 3EP',
                        controller: _postcodeController,
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.next,
                        hasError: _postcodeError,
                        onChanged: _onPostcodeChanged,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                _PostcodeStatusLine(
                  isLookingUp: state.isLookingUpPostcode,
                  status: state.postcodeStatus,
                  city: draft.city,
                  postcode: draft.postcode,
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Text('Pin location', style: AppTextStyles.bodySecondary),
                    const Spacer(),
                    if (draft.hasCoordinates)
                      Text('Tap to adjust', style: AppTextStyles.caption),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Semantics(
                  button: true,
                  label: 'Adjust your exact location on the map',
                  child: GestureDetector(
                    onTap: _openMap,
                    child: ClipRRect(
                      borderRadius: AppRadius.rSm,
                      child: AddressMapPreview(
                        latitude: draft.latitude,
                        longitude: draft.longitude,
                        postcode: draft.postcode,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        RegistrationFooter(label: 'Continue', onPressed: _continue),
      ],
    );
  }
}

class _SuggestionList extends StatelessWidget {
  final List<AddressSuggestion> suggestions;
  final ValueChanged<AddressSuggestion> onSelected;

  const _SuggestionList({
    required this.suggestions,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.rSm,
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var index = 0; index < suggestions.length; index++) ...[
            InkWell(
              onTap: () => onSelected(suggestions[index]),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.place_outlined,
                      size: AppIconSize.sm,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        suggestions[index].label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: AppIconSize.sm,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
            if (index < suggestions.length - 1)
              const Divider(height: 1, color: AppColors.divider),
          ],
        ],
      ),
    );
  }
}

class _PostcodeStatusLine extends StatelessWidget {
  final bool isLookingUp;
  final PostcodeLookupStatus? status;
  final String city;
  final String postcode;

  const _PostcodeStatusLine({
    required this.isLookingUp,
    required this.status,
    required this.city,
    required this.postcode,
  });

  @override
  Widget build(BuildContext context) {
    if (isLookingUp) {
      return Row(
        children: [
          const SizedBox(
            width: AppIconSize.xs,
            height: AppIconSize.xs,
            child: AppLoading(size: AppIconSize.xs, strokeWidth: 2),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text('Validating postcode…', style: AppTextStyles.caption),
        ],
      );
    }
    if (status == null) return const SizedBox.shrink();

    switch (status!) {
      case PostcodeLookupStatus.success:
        final detail = city.trim().isEmpty
            ? postcode.trim()
            : '${postcode.trim()} · ${city.trim()}';
        return Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: AppIconSize.xs,
              color: AppColors.successText,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                detail,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.successText,
                ),
              ),
            ),
          ],
        );
      case PostcodeLookupStatus.invalidFormat:
        return _PostcodeMessage('Enter a full UK postcode, e.g. MK9 3EP.');
      case PostcodeLookupStatus.notFound:
        return _PostcodeMessage('No matching postcode found.');
      case PostcodeLookupStatus.failed:
        return _PostcodeMessage(
          'Postcode lookup failed. Check your connection and try again.',
        );
    }
  }
}

class _PostcodeMessage extends StatelessWidget {
  final String message;

  const _PostcodeMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.error_outline,
          size: AppIconSize.xs,
          color: AppColors.errorText,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            message,
            style: AppTextStyles.caption.copyWith(color: AppColors.errorText),
          ),
        ),
      ],
    );
  }
}
