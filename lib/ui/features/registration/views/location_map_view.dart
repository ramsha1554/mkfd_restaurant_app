import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/animations/app_durations.dart';
import '../../../../core/constants/app_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/registration_provider.dart';

class LocationMapView extends ConsumerStatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;

  const LocationMapView({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  @override
  ConsumerState<LocationMapView> createState() => _LocationMapViewState();
}

class _LocationMapViewState extends ConsumerState<LocationMapView> {
  late LatLng _point;
  Timer? _reverseTimer;
  String? _label;
  bool _isDescribing = false;

  @override
  void initState() {
    super.initState();
    _point = LatLng(
      widget.initialLatitude ?? 52.0406,
      widget.initialLongitude ?? -0.7594,
    );
    _scheduleDescribe();
  }

  @override
  void dispose() {
    _reverseTimer?.cancel();
    super.dispose();
  }

  void _movePin(LatLng point) {
    setState(() {
      _point = point;
      _label = null;
    });
    _scheduleDescribe();
  }

  void _scheduleDescribe() {
    _reverseTimer?.cancel();
    _reverseTimer = Timer(AppDurations.reverseDebounce, () async {
      if (!mounted) return;
      setState(() => _isDescribing = true);
      final suggestion = await ref
          .read(registrationProvider.notifier)
          .describePoint(_point.latitude, _point.longitude);
      if (!mounted) return;
      setState(() {
        _label = suggestion?.label;
        _isDescribing = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: 'Adjust your location'),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: _point,
                    initialZoom: 16,
                    onTap: (_, point) => _movePin(point),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: AppConfig.osmTileUrl,
                      userAgentPackageName: AppConfig.packageName,
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _point,
                          width: 44,
                          height: 44,
                          child: const Icon(
                            Icons.location_on,
                            size: 44,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: AppSpacing.md,
                  left: AppSpacing.md,
                  right: AppSpacing.md,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadius.rSm,
                        border: Border.all(
                          color: AppColors.cardBorder,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Tap the map to move the pin.',
                        style: AppTextStyles.caption,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: AppSpacing.xs,
                  bottom: AppSpacing.xs,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.85),
                      borderRadius: AppRadius.rXs,
                    ),
                    child: Text(
                      AppConfig.osmAttribution,
                      style: AppTextStyles.eyebrow.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(
                top: BorderSide(color: AppColors.cardBorder, width: 1),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isDescribing)
                          const Padding(
                            padding: EdgeInsets.only(top: AppSpacing.xs),
                            child: AppLoading(size: 16, strokeWidth: 2),
                          )
                        else
                          const Icon(
                            Icons.place_outlined,
                            size: AppIconSize.sm,
                            color: AppColors.textSecondary,
                          ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            _isDescribing
                                ? 'Finding the nearest address…'
                                : (_label ??
                                    '${_point.latitude.toStringAsFixed(5)}, '
                                        '${_point.longitude.toStringAsFixed(5)}'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppPrimaryButton(
                      label: 'Use this location',
                      onPressed: () => Navigator.of(context).pop(_point),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
