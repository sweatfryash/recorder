import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Widget? child;
  final String image;
  final double size;
  final VoidCallback? onTap;
  const MyButton({Key? key, this.child, required this.image, this.onTap, required this.size})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        width: size,
        height: size,
        child: Stack(
          children: [
            Center(child: Image.asset('assets/images/$image.png')),
            Center(child: child ?? Container())
          ],
        ),
      ),
    );
  }
}
