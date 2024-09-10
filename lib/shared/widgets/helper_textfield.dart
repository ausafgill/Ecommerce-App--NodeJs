import 'package:flutter/material.dart';

class HelperTextField extends StatelessWidget {
  final String htxt;
  final TextEditingController controller;
  //final IconData iconData;
  final maxLines;
  final bool obscure;
  final Function? validator;
  final Function(String)? onChanged;
  final TextInputType keyboardType;
  const HelperTextField({
    super.key,
    required this.htxt,
    this.maxLines = 1,
    // required this.iconData,
    required this.controller,
    required this.keyboardType,
    this.onChanged,
    this.obscure = false,
    this.validator,
  });

  valid(String? value) {
    if (validator == null) {
      return null;
    } else {
      return validator!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        onFieldSubmitted: onChanged,
        validator: (val) => valid(val),
        obscureText: obscure,
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: htxt,
          // fillColor: EColors.white,
          //filled: true,
          border: const OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.black38,
          )),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.black38,
          )),
          // prefixIcon: Icon(iconData),
        ),
      ),
    );
  }
}
