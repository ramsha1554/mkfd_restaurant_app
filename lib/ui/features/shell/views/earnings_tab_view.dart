import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_states.dart';

class EarningsTabView extends StatelessWidget {
  const EarningsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: 'Earnings'),
      body: const Center(
        child: AppEmptyState(
          icon: Icons.payments_outlined,
          title: 'Your earnings will appear here',
        ),
      ),
    );
  }
}
