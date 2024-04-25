import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/products/cart/cart_menu_icon.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';

class FVHomeAppBar extends StatelessWidget {
  const FVHomeAppBar({
    super.key,
  });

  final String name = "";
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final FirebaseDatabase database = FirebaseDatabase.instance;
    final firebaseApp = Firebase.app();
    final ref = FirebaseDatabase.instance.ref();
    Future<String> way() async {
      final sn = await ref.child('User/${_auth.currentUser!.uid}').get();
      return sn.child("Username").value.toString();
    }
    return FVAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            FVText.homeAppbarTitle,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .apply(color: FVColors.grey),
          ),
          Text(
            "${way()}",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .apply(color: FVColors.white),
          ),
        ],
      ),
      actions: [
        FVCartCounterIcon(
            onPressed: () {},
            iconColor: FVColors.white,
            counterBgColor: FVColors.black,
            counterTextColor: FVColors.white),
      ],
    );
  }
}
