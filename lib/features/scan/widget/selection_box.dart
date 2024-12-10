import 'package:demo/utils/constant/sizes.dart';
import 'package:flutter/material.dart';

Widget SelectionBox(Widget widget,
    {required Color backgroundColor,
    required Color splashColor,
    required Color highlightColor,
    required void onPress()}) {
  return Material(
    color: backgroundColor,
    clipBehavior: Clip.hardEdge,
    borderRadius: BorderRadius.circular(Sizes.lg),
    child: SizedBox(
      width: double.maxFinite,
      child: InkWell(
        splashColor: splashColor,
        highlightColor: highlightColor,
        onTap: onPress,
        child: Padding(padding: const EdgeInsets.all(Sizes.lg), child: widget),
      ),
    ),
  );
}
