import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/auth_provider.dart';
import 'welcome_view.dart';

class SignedInView extends ConsumerWidget {
  const SignedInView({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(authProvider.notifier).logout();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      slideRightFadeRoute(const WelcomeView()),
      (r) => false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('Signed in', style: AppTextStyles.h2),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name?.isNotEmpty == true ? user!.name! : 'Restaurant Owner',
                      style: AppTextStyles.cardTitle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.phone ?? auth.phone ?? '',
                      style: AppTextStyles.bodySecondary,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? '',
                      style: AppTextStyles.bodySecondary,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              AppPrimaryButton(
                label: 'Log out',
                onPressed: () => _logout(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.name ?? 'Restaurant owner',
                                style: AppTextStyles.bodyLarge,
                              ),
                              Text(
                                user?.phone ?? auth.phone ?? '—',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            borderRadius: AppRadius.rPill,
                          ),
                          child: Text(
                            'VERIFIED',
                            style: AppTextStyles.caption
                                .copyWith(color: AppColors.surface),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Divider(height: 1),
                    const SizedBox(height: AppSpacing.md),
                    Text('You are signed in. Phase 1 placeholder — restaurant setup comes in Phase 2.',
                        style: AppTextStyles.body),
                  ],
                ),
              ),
              const Spacer(),
              SecondaryButton(
                label: 'Logout',
                icon: Icons.logout_outlined,
                isLoading: auth.isLoading,
                onPressed: auth.isLoading ? null : () => _logout(context, ref),
              ),
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                label: 'Continue (placeholder)',
                onPressed: () {},
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}


