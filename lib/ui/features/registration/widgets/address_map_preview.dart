import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  final VoidCallback? onTap;

  const AddressMapPreview({
    super.key,
    required this.latitude,
    required this.longitude,
    this.height = 180,
    this.postcode = '',
    this.showPostcodeChip = true,
    this.onTap,
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
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: point, zoom: 16),
              markers: {
                Marker(
                  markerId: const MarkerId('restaurant-preview'),
                  position: point,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueOrange,
                  ),
                ),
              },
              liteModeEnabled: true,
              zoomControlsEnabled: false,
              scrollGesturesEnabled: false,
              zoomGesturesEnabled: false,
              rotateGesturesEnabled: false,
              tiltGesturesEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
            ),
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
          if (onTap != null)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap,
              ),
            ),
        ],
      ),
    );
  }
}
