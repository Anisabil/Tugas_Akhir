import 'package:flutter/material.dart';
import 'package:fvapp/admin/screens/packages/packages.dart';
import 'package:fvapp/admin/screens/profile/profile_admin.dart';
import 'package:fvapp/admin/screens/rent_order/rent_order.dart';
import 'package:fvapp/admin/screens/rent_order/widgets/rent_detail.dart';
import 'package:fvapp/common/widgets/appbar/appbar.dart';
import 'package:get/get.dart';

import '../../common/widgets/appbar/tabbar.dart';
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
      length: 4,
      child: Scaffold(
        appBar: FVAppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image(
                height: 50,
                image: AssetImage(
                  dark ? FVImages.mylogo : FVImages.mylogo,
                ),
              ),
              Text(
                'Halo Admin',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
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
                                  ? FVImages.mylogo
                                  : FVImages.mylogo,
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
          body: TabBarView(
            children: [
              SettingCategories(),
              SettingPackages(),
              RentalList(),
              const ProfileAdmin(),
            ],
          ),
        ),
      ),
    );
  }
}
