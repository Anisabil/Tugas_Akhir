import 'package:flutter/material.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';

class MultiStepFormIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const MultiStepFormIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        return Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: index == currentStep ? FVColors.gold : FVColors.grey,
              child: Text(
                (index + 1).toString(),
                style: TextStyle(
                  color: FVColors.white,
                ),
              ),
            ),
            if (index < totalSteps - 1)
              Container(
                width: 20,
                height: 2,
                color: FVColors.grey,
              ),
          ],
        );
      }),
    );
  }
}
