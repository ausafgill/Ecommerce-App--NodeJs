import 'package:amazon/constants/gloabal_variable.dart';
import 'package:flutter/material.dart';

class HelperButton extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final Color? color;
  bool isLoading;
  HelperButton(
      {super.key,
      required this.name,
      required this.onTap,
      this.color,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: color ?? GlobalVariables.secondaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Center(
                  child: Text(
                    name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
        ),
      ),
    );
  }
}
