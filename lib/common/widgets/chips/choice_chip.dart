import 'package:flutter/material.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';

import '../../../utils/constants/colors.dart';
import '../custom_shapes/containers/circular_container.dart';

class FVChoiceChip extends StatelessWidget {
  const FVChoiceChip({
    super.key,
    required this.text,
    required this.selected,
    this.onSelected,
  });

  final String text;
  final bool selected;
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    final isColor = FVHelperFunctions.getColor(text) != null;
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: ChoiceChip(
        label: isColor ? const SizedBox() : Text(text),
        selected: selected,
        onSelected: onSelected,
        labelStyle: TextStyle(color: selected ? FVColors.white : null),
        avatar: isColor
            ? FVCircularContainer(
                width: 50,
                height: 50,
                backgroundColor: FVHelperFunctions.getColor(text)!)
            : null,
        shape: isColor ? const CircleBorder() : null,
        labelPadding: isColor ? const EdgeInsets.all(0) : null,
        padding: isColor ? const EdgeInsets.all(0) : null,
        backgroundColor: isColor ? FVHelperFunctions.getColor(text)! : null,
      ),
    );
  }
}
