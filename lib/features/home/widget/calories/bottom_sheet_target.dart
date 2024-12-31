import 'package:demo/features/home/controller/user_target_controller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class BottomSheetTarget extends ConsumerStatefulWidget {
  final String label;
  final double maximum;
  final value;
  BottomSheetTarget(
      {super.key,
      required this.label,
      required this.maximum,
      required this.value});

  @override
  ConsumerState<BottomSheetTarget> createState() => _BottomSheetTargetState();
}

class _BottomSheetTargetState extends ConsumerState<BottomSheetTarget> {
  var _target = 1;
  @override
  void initState() {
    // TODO: implement initState
    _target = widget.value;
    super.initState();
  }

  String getLabel(type) {
    if (type == 'Steps') {
      return 'step';
    } else if (type == 'Sleep') {
      return 'hour';
    } else {
      return 'kcal';
    }
  }

  @override
  Widget build(BuildContext context) {
    String units = getLabel(widget.label);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        ref
            .read(userTargetControllerProvider.notifier)
            .updateTarget(widget.label, _target.toString(), ref);
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        // width: double.maxFinite,
        height: 22.h,
        // height: 28.h,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "${widget.label}",
                  style: AppTextTheme.lightTextTheme?.headlineSmall?.copyWith(
                      color: AppColors.backgroundDark,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Center(
                child: Slider(
                  label: _target.toString(),
                  value: _target.toDouble(),
                  // divisions: (widget.maximum / 10).toInt(),
                  // divisions: 1,
                  onChanged: (value) {
                    setState(() {
                      _target = value.toInt();
                    });
                  },
                  activeColor: AppColors.primaryColor,
                  inactiveColor: AppColors.primaryGrey,
                  min: 0,
                  divisions: 10,

                  // autofocus: true,
                  // allowedInteraction: SliderInteraction.tapAndSlide,
                  max: widget.maximum ?? 100,
                ),
              ),
              const SizedBox(
                height: Sizes.md,
              ),
              Center(
                child: Text(
                  "Set your ${widget.label} target ${_target} ${units}",
                  textAlign: TextAlign.center,
                  style: AppTextTheme.lightTextTheme?.labelLarge?.copyWith(
                      color: AppColors.backgroundDark,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
