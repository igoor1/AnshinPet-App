import 'package:flutter/material.dart';

class AppbarCustom extends StatelessWidget implements PreferredSizeWidget {
  const AppbarCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        Image.asset(
          'images/logo_minimal.png',
          height: 35,
        )
      ],
      actionsPadding: EdgeInsets.fromLTRB(0, 5, 15, 2),
      surfaceTintColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
