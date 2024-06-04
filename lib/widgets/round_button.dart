import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const RoundButton({super.key, required this.title, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff10263C),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
            child: Text(title)),
      ) ,
    );
  }
}
