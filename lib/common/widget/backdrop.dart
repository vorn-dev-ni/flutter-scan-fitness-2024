import 'package:flutter/material.dart';

Widget backDropComponent() {
  return Positioned.fill(
    child: GestureDetector(
      onTap: () {},
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: const Center(
            child: SizedBox(
                width: 50,
                height: 50,
                child: const CircularProgressIndicator())),
      ),
    ),
  );
}
