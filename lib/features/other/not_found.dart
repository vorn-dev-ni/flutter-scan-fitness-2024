import 'package:demo/common/widget/bodyno_found.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  late final String description;
  NotFoundScreen({super.key, this.description = "Oops Page not Found"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.xxxl),
            child: bodyNoFound(context, description,
                body:
                    "This screen doesnt exist or you don't have permission to view it",
                showButton: false),
          ),
        ),
      ),
    );
  }
}
