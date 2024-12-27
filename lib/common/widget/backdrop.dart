import 'package:flutter/material.dart';

Widget backDropComponent() {
  return Positioned.fill(
    top: 0,
    left: 0,
    right: 0,
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
