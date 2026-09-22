import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class CountryCode {
  final String name;
  final String dialCode;
  final String flag;

  const CountryCode(this.name, this.dialCode, this.flag);
}

const List<CountryCode> kCountryCodes = [
  CountryCode('Afghanistan', '+93', '🇦🇫'),
  CountryCode('Albania', '+355', '🇦🇱'),
  CountryCode('Algeria', '+213', '🇩🇿'),
  CountryCode('Andorra', '+376', '🇦🇩'),
  CountryCode('Angola', '+244', '🇦🇴'),
  CountryCode('Argentina', '+54', '🇦🇷'),
  CountryCode('Armenia', '+374', '🇦🇲'),
  CountryCode('Australia', '+61', '🇦🇺'),
  CountryCode('Austria', '+43', '🇦🇹'),
  CountryCode('Azerbaijan', '+994', '🇦🇿'),
  CountryCode('Bahrain', '+973', '🇧🇭'),
  CountryCode('Bangladesh', '+880', '🇧🇩'),
  CountryCode('Belarus', '+375', '🇧🇾'),
  CountryCode('Belgium', '+32', '🇧🇪'),
  CountryCode('Belize', '+501', '🇧🇿'),
  CountryCode('Benin', '+229', '🇧🇯'),
  CountryCode('Bhutan', '+975', '🇧🇹'),
  CountryCode('Bolivia', '+591', '🇧🇴'),
  CountryCode('Bosnia & Herzegovina', '+387', '🇧🇦'),
  CountryCode('Botswana', '+267', '🇧🇼'),
  CountryCode('Brazil', '+55', '🇧🇷'),
  CountryCode('Brunei', '+673', '🇧🇳'),
  CountryCode('Bulgaria', '+359', '🇧🇬'),
  CountryCode('Burkina Faso', '+226', '🇧🇫'),
  CountryCode('Burundi', '+257', '🇧🇮'),
  CountryCode('Cambodia', '+855', '🇰🇭'),
  CountryCode('Cameroon', '+237', '🇨🇲'),
  CountryCode('Canada', '+1', '🇨🇦'),
  CountryCode('Cape Verde', '+238', '🇨🇻'),
  CountryCode('Central African Republic', '+236', '🇨🇫'),
  CountryCode('Chad', '+235', '🇹🇩'),
  CountryCode('Chile', '+56', '🇨🇱'),
  CountryCode('China', '+86', '🇨🇳'),
  CountryCode('Colombia', '+57', '🇨🇴'),
  CountryCode('Comoros', '+269', '🇰🇲'),
  CountryCode('Congo', '+242', '🇨🇬'),
  CountryCode('Costa Rica', '+506', '🇨🇷'),
  CountryCode('Croatia', '+385', '🇭🇷'),
  CountryCode('Cuba', '+53', '🇨🇺'),
  CountryCode('Cyprus', '+357', '🇨🇾'),
  CountryCode('Czech Republic', '+420', '🇨🇿'),
  CountryCode('Denmark', '+45', '🇩🇰'),
  CountryCode('Djibouti', '+253', '🇩🇯'),
  CountryCode('Dominican Republic', '+1', '🇩🇴'),
  CountryCode('DR Congo', '+243', '🇨🇩'),
  CountryCode('Ecuador', '+593', '🇪🇨'),
  CountryCode('Egypt', '+20', '🇪🇬'),
  CountryCode('El Salvador', '+503', '🇸🇻'),
  CountryCode('Estonia', '+372', '🇪🇪'),
  CountryCode('Eswatini', '+268', '🇸🇿'),
  CountryCode('Ethiopia', '+251', '🇪🇹'),
  CountryCode('Fiji', '+679', '🇫🇯'),
  CountryCode('Finland', '+358', '🇫🇮'),
  CountryCode('France', '+33', '🇫🇷'),
  CountryCode('Gabon', '+241', '🇬🇦'),
  CountryCode('Gambia', '+220', '🇬🇲'),
  CountryCode('Georgia', '+995', '🇬🇪'),
  CountryCode('Germany', '+49', '🇩🇪'),
  CountryCode('Ghana', '+233', '🇬🇭'),
  CountryCode('Greece', '+30', '🇬🇷'),
  CountryCode('Guatemala', '+502', '🇬🇹'),
  CountryCode('Guinea', '+224', '🇬🇳'),
  CountryCode('Guinea-Bissau', '+245', '🇬🇼'),
  CountryCode('Guyana', '+592', '🇬🇾'),
  CountryCode('Haiti', '+509', '🇭🇹'),
  CountryCode('Honduras', '+504', '🇭🇳'),
  CountryCode('Hong Kong', '+852', '🇭🇰'),
  CountryCode('Hungary', '+36', '🇭🇺'),
  CountryCode('Iceland', '+354', '🇮🇸'),
  CountryCode('India', '+91', '🇮🇳'),
  CountryCode('Indonesia', '+62', '🇮🇩'),
  CountryCode('Iran', '+98', '🇮🇷'),
  CountryCode('Iraq', '+964', '🇮🇶'),
  CountryCode('Ireland', '+353', '🇮🇪'),
  CountryCode('Israel', '+972', '🇮🇱'),
  CountryCode('Italy', '+39', '🇮🇹'),
  CountryCode('Ivory Coast', '+225', '🇨🇮'),
  CountryCode('Jamaica', '+1', '🇯🇲'),
  CountryCode('Japan', '+81', '🇯🇵'),
  CountryCode('Jordan', '+962', '🇯🇴'),
  CountryCode('Kazakhstan', '+7', '🇰🇿'),
  CountryCode('Kenya', '+254', '🇰🇪'),
  CountryCode('Kiribati', '+686', '🇰🇮'),
  CountryCode('Kosovo', '+383', '🇽🇰'),
  CountryCode('Kuwait', '+965', '🇰🇼'),
  CountryCode('Kyrgyzstan', '+996', '🇰🇬'),
  CountryCode('Laos', '+856', '🇱🇦'),
  CountryCode('Latvia', '+371', '🇱🇻'),
  CountryCode('Lebanon', '+961', '🇱🇧'),
  CountryCode('Lesotho', '+266', '🇱🇸'),
  CountryCode('Liberia', '+231', '🇱🇷'),
  CountryCode('Libya', '+218', '🇱🇾'),
  CountryCode('Liechtenstein', '+423', '🇱🇮'),
  CountryCode('Lithuania', '+370', '🇱🇹'),
  CountryCode('Luxembourg', '+352', '🇱🇺'),
  CountryCode('Madagascar', '+261', '🇲🇬'),
  CountryCode('Malawi', '+265', '🇲🇼'),
  CountryCode('Malaysia', '+60', '🇲🇾'),
  CountryCode('Maldives', '+960', '🇲🇻'),
  CountryCode('Mali', '+223', '🇲🇱'),
  CountryCode('Malta', '+356', '🇲🇹'),
  CountryCode('Mauritania', '+222', '🇲🇷'),
  CountryCode('Mauritius', '+230', '🇲🇺'),
  CountryCode('Mexico', '+52', '🇲🇽'),
  CountryCode('Micronesia', '+691', '🇫🇲'),
  CountryCode('Moldova', '+373', '🇲🇩'),
  CountryCode('Monaco', '+377', '🇲🇨'),
  CountryCode('Mongolia', '+976', '🇲🇳'),
  CountryCode('Montenegro', '+382', '🇲🇪'),
  CountryCode('Morocco', '+212', '🇲🇦'),
  CountryCode('Mozambique', '+258', '🇲🇿'),
  CountryCode('Myanmar', '+95', '🇲🇲'),
  CountryCode('Namibia', '+264', '🇳🇦'),
  CountryCode('Nepal', '+977', '🇳🇵'),
  CountryCode('Netherlands', '+31', '🇳🇱'),
  CountryCode('New Zealand', '+64', '🇳🇿'),
  CountryCode('Nicaragua', '+505', '🇳🇮'),
  CountryCode('Niger', '+227', '🇳🇪'),
  CountryCode('Nigeria', '+234', '🇳🇬'),
  CountryCode('North Macedonia', '+389', '🇲🇰'),
  CountryCode('Norway', '+47', '🇳🇴'),
  CountryCode('Oman', '+968', '🇴🇲'),
  CountryCode('Pakistan', '+92', '🇵🇰'),
  CountryCode('Palau', '+680', '🇵🇼'),
  CountryCode('Palestine', '+970', '🇵🇸'),
  CountryCode('Panama', '+507', '🇵🇦'),
  CountryCode('Papua New Guinea', '+675', '🇵🇬'),
  CountryCode('Paraguay', '+595', '🇵🇾'),
  CountryCode('Peru', '+51', '🇵🇪'),
  CountryCode('Philippines', '+63', '🇵🇭'),
  CountryCode('Poland', '+48', '🇵🇱'),
  CountryCode('Portugal', '+351', '🇵🇹'),
  CountryCode('Qatar', '+974', '🇶🇦'),
  CountryCode('Romania', '+40', '🇷🇴'),
  CountryCode('Russia', '+7', '🇷🇺'),
  CountryCode('Rwanda', '+250', '🇷🇼'),
  CountryCode('Samoa', '+685', '🇼🇸'),
  CountryCode('San Marino', '+378', '🇸🇲'),
  CountryCode('Saudi Arabia', '+966', '🇸🇦'),
  CountryCode('Senegal', '+221', '🇸🇳'),
  CountryCode('Serbia', '+381', '🇷🇸'),
  CountryCode('Seychelles', '+248', '🇸🇨'),
  CountryCode('Sierra Leone', '+232', '🇸🇱'),
  CountryCode('Singapore', '+65', '🇸🇬'),
  CountryCode('Slovakia', '+421', '🇸🇰'),
  CountryCode('Slovenia', '+386', '🇸🇮'),
  CountryCode('Solomon Islands', '+677', '🇸🇧'),
  CountryCode('Somalia', '+252', '🇸🇴'),
  CountryCode('South Africa', '+27', '🇿🇦'),
  CountryCode('South Korea', '+82', '🇰🇷'),
  CountryCode('Spain', '+34', '🇪🇸'),
  CountryCode('Sri Lanka', '+94', '🇱🇰'),
  CountryCode('Sudan', '+249', '🇸🇩'),
  CountryCode('Suriname', '+597', '🇸🇷'),
  CountryCode('Sweden', '+46', '🇸🇪'),
  CountryCode('Switzerland', '+41', '🇨🇭'),
  CountryCode('Syria', '+963', '🇸🇾'),
  CountryCode('Taiwan', '+886', '🇹🇼'),
  CountryCode('Tajikistan', '+992', '🇹🇯'),
  CountryCode('Tanzania', '+255', '🇹🇿'),
  CountryCode('Thailand', '+66', '🇹🇭'),
  CountryCode('Togo', '+228', '🇹🇬'),
  CountryCode('Tonga', '+676', '🇹🇴'),
  CountryCode('Tunisia', '+216', '🇹🇳'),
  CountryCode('Turkey', '+90', '🇹🇷'),
  CountryCode('Turkmenistan', '+993', '🇹🇲'),
  CountryCode('Tuvalu', '+688', '🇹🇻'),
  CountryCode('Uganda', '+256', '🇺🇬'),
  CountryCode('Ukraine', '+380', '🇺🇦'),
  CountryCode('United Arab Emirates', '+971', '🇦🇪'),
  CountryCode('United Kingdom', '+44', '🇬🇧'),
  CountryCode('United States', '+1', '🇺🇸'),
  CountryCode('Uruguay', '+598', '🇺🇾'),
  CountryCode('Uzbekistan', '+998', '🇺🇿'),
  CountryCode('Vanuatu', '+678', '🇻🇺'),
  CountryCode('Vatican City', '+379', '🇻🇦'),
  CountryCode('Venezuela', '+58', '🇻🇪'),
  CountryCode('Vietnam', '+84', '🇻🇳'),
  CountryCode('Yemen', '+967', '🇾🇪'),
  CountryCode('Zambia', '+260', '🇿🇲'),
  CountryCode('Zimbabwe', '+263', '🇿🇼'),
];

class CountrySelector extends StatelessWidget {
  final CountryCode selected;
  final ValueChanged<CountryCode> onSelected;

  const CountrySelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showPicker(context),
      borderRadius: AppRadius.rSm,
      child: Container(
        padding: AppSpacing.mdAll,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.rSm,
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(selected.flag, style: AppTextStyles.body),
            const SizedBox(width: AppSpacing.sm),
            Text(selected.dialCode, style: AppTextStyles.bodyLarge),
            const SizedBox(width: AppSpacing.xs),
            const Icon(Icons.arrow_drop_down, size: 20, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => _CountryPickerSheet(
        selected: selected,
        onSelected: onSelected,
      ),
    );
  }
}

class _CountryPickerSheet extends StatefulWidget {
  final CountryCode selected;
  final ValueChanged<CountryCode> onSelected;

  const _CountryPickerSheet({
    required this.selected,
    required this.onSelected,
  });

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() => _query = _searchCtrl.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<CountryCode> get _filtered {
    if (_query.isEmpty) return kCountryCodes;
    final q = _query;
    final qDigits = q.replaceAll(RegExp(r'[^0-9+]'), '');
    return kCountryCodes.where((c) {
      final name = c.name.toLowerCase();
      final code = c.dialCode.toLowerCase();
      if (name.contains(q)) return true;
      if (code.contains(q)) return true;
      if (qDigits.isNotEmpty && code.contains(qDigits)) return true;
      if (qDigits.isNotEmpty && code.replaceAll('+', '').contains(qDigits.replaceAll('+', ''))) {
        return true;
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollCtrl) {
            return Column(
              children: [
                const SizedBox(height: AppSpacing.sm),
                Container(
                  width: 36,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: AppRadius.rPill,
                  ),
                ),
                Padding(
                  padding: AppSpacing.lgAll,
                  child: Text('Select country', style: AppTextStyles.title),
                ),
                Padding(
                  padding: AppSpacing.screenPaddingH,
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: 'Search country or code',
                      prefixIcon: const Icon(
                        Icons.search_outlined,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear_outlined,
                                size: 20,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: () => _searchCtrl.clear(),
                            )
                          : null,
                    ),
                    textInputAction: TextInputAction.search,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const Divider(height: 1),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Padding(
                            padding: AppSpacing.xlAll,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.search_off_outlined,
                                  size: 32,
                                  color: AppColors.textHint,
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  'No results for "$_query"',
                                  style: AppTextStyles.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.separated(
                          controller: scrollCtrl,
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, i) {
                            final c = filtered[i];
                            final isSelected = c.dialCode == widget.selected.dialCode &&
                                c.name == widget.selected.name;
                            return ListTile(
                              leading: Text(c.flag, style: AppTextStyles.title),
                              title: Text(c.name, style: AppTextStyles.body),
                              trailing: Text(c.dialCode, style: AppTextStyles.bodyLarge),
                              selected: isSelected,
                              selectedTileColor: AppColors.primaryLight,
                              onTap: () {
                                Navigator.of(context).pop();
                                widget.onSelected(c);
                              },
                            );
                          },
                        ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            );
          },
        ),
      ),
    );
  }
}
