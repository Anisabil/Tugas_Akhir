import 'package:flutter/material.dart';
import 'package:fvapp/utils/constants/device_utility.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_function.dart';

class FVTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// To do that we need [PreferredSize] Widget and that's why created custom class. [PreferredSizeWidget]
  const FVTabBar({
    super.key,
    required this.tabs,
  });

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);

    return Material(
      color: dark ? FVColors.black : FVColors.white,
      child: TabBar(
        tabs: tabs,
        isScrollable: true,
        indicatorColor: FVColors.gold,
        unselectedLabelColor: FVColors.darkGrey,
        labelColor: dark ? FVColors.white : FVColors.gold,
      ),
    );
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(FVDeviceUtils.getAppBarHeight());
}
