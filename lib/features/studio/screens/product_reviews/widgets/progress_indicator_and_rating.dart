import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/device_utility.dart';

class FVRatingProgressIndicatior extends StatelessWidget {
  const FVRatingProgressIndicatior({
    super.key,
    required this.text,
    required this.value,
  });

  final String text;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Expanded(
          flex: 11,
          child: SizedBox(
            width: FVDeviceUtils.getScreenWidth(context) * 0.8,
            child: LinearProgressIndicator(
              value: value,
              minHeight: 11,
              backgroundColor: FVColors.grey,
              valueColor: const AlwaysStoppedAnimation(FVColors.teal),
            ),
          ),
        )
      ],
    );
  }
}
