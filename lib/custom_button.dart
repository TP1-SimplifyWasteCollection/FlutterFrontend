import 'package:flutter/material.dart';
class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  CustomFloatingActionButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/your_image.png'), // Update with your image path
              fit: BoxFit.cover,
            ),
          ),
        ),
        FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: Colors.transparent, // Transparent to show the image
          child: Icon(Icons.location_on), // Replace with your desired icon
        ),
      ],
    );
  }
}
