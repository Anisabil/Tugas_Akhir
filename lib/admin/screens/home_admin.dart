import 'package:flutter/material.dart';
import 'package:fvapp/admin/screens/home/home_body.dart';
import 'package:fvapp/admin/screens/packages/packages.dart';

import '../../common/widgets/appbar/tabbar.dart';
import '../../features/studio/screens/rent/widgets/category_tab.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_function.dart';
import 'categories/categories.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                backgroundColor: FVHelperFunctions.isDarkMode(context)
                    ? FVColors.black
                    : FVColors.white,
                expandedHeight: 400,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(FVSizes.defaultSpace),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // logo
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                            height: 400,
                            image: AssetImage(
                              dark
                                  ? FVImages.lightAppLogo
                                  : FVImages.darkAppLogo,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                // Tabs
                bottom: const FVTabBar(
                  tabs: [
                    Tab(
                      child: Text('Beranda'),
                    ),
                    Tab(
                      child: Text('Kategori'),
                    ),
                    Tab(
                      child: Text('Paket'),
                    ),
                    Tab(
                      child: Text('Sewa'),
                    ),
                    Tab(
                      child: Text('Profil'),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: const TabBarView(
            children: [
              HomeBody(),
              SettingCategories(),
              Packages(),
              HomeBody(),
              HomeBody(),
            ],
          ),
        ),
      ),
    );
  }
}
