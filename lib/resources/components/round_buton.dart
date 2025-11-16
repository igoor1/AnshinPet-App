import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final bool loading;
  final VoidCallback onPress;
  const RoundButton({super.key,
    required this.title,
    this.loading = false,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: 45,
        width: 200,
        decoration: BoxDecoration(
          color: Color.fromRGBO(124, 84, 217, 1),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: loading 
          ? SizedBox(
            height: 24,
            width: 24, 
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
          ) 
          : Text(title, style: TextStyle(color: Colors.white),
        )),
      ),
    );
  }
}
