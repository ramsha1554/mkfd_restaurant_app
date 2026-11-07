import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/constants/app_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class AddressMapPreview extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final double height;
  final String postcode;
  final bool showPostcodeChip;

  const AddressMapPreview({
    super.key,
    required this.latitude,
    required this.longitude,
    this.height = 180,
    this.postcode = '',
    this.showPostcodeChip = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasPoint = latitude != null && longitude != null;
    if (!hasPoint) {
      return Container(
        height: height,
        color: AppColors.cardBackground,
        alignment: Alignment.center,
        padding: AppSpacing.xlAll,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_off_outlined,
              size: AppIconSize.lg,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Search your address to place the pin.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),
          ],
        ),
      );
    }

    final point = LatLng(latitude!, longitude!);
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: point,
              initialZoom: 16,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.none,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: AppConfig.osmTileUrl,
                userAgentPackageName: AppConfig.packageName,
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: point,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_on,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (showPostcodeChip && postcode.trim().isNotEmpty)
            Positioned(
              top: AppSpacing.sm,
              left: AppSpacing.sm,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.rXs,
                  border: Border.all(color: AppColors.cardBorder, width: 1),
                ),
                child: Text(
                  '${postcode.trim()} Pinpoint',
                  style: AppTextStyles.eyebrow.copyWith(
                    color: AppColors.textPrimary,
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
    );
  }
}
