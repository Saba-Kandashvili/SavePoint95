import 'package:flutter/material.dart';
import 'package:savepoint95/core/theme/app_colors.dart';

class W95TextInput extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;

  const W95TextInput({super.key, required this.controller, this.hintText});

  @override
  Widget build(BuildContext context) {
    // sunken container
    return Container(
      height: 30, // win 95 inputs were short
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ), // text shouldnt touch wall

      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          // SUNKEN: Dark on top/left, Light on bottom/right
          top: BorderSide(color: AppColors.darkShadow, width: 2.0),
          left: BorderSide(color: AppColors.darkShadow, width: 2.0),
          right: BorderSide(color: AppColors.highlight, width: 2.0),
          bottom: BorderSide(color: AppColors.highlight, width: 2.0),
        ),
      ),
      // input
      child: Center(
        // alignt text vertically
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            isDense: true, // remove default padding
            border: InputBorder.none, // remove default border
            contentPadding: EdgeInsets.zero, // remove default content padding
          ),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: "Courier", // or standard sans serif
          ),
          cursorColor: Colors.black,
          cursorWidth: 1.0,
        ),
      ),
    );
  }
}
