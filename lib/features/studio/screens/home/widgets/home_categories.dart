import 'package:flutter/material.dart';

import '../../../../../common/widgets/image_text_widgets/vertical_image_text.dart';
import '../../../../../utils/constants/image_strings.dart';

class FVHomeCategories extends StatelessWidget {
  const FVHomeCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 6,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          return FVVerticalImageText(
            image: FVImages.iconWedding,
            title: 'Wedding',
            onTap: () {},
          );
        },
      ),
    );
  }
}

