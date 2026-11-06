import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_states.dart';

class MenuTabView extends StatelessWidget {
  const MenuTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: 'Menu'),
      body: const Center(
        child: AppEmptyState(
          icon: Icons.restaurant_menu_outlined,
          title: 'Your menu will appear here',
        ),
      ),
    );
  }
}
