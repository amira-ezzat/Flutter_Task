import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:  AppColors.lightBackground,
      title: Center(
        child: Text('التصنيفات',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText)),
      ),
      actions: [
        IconButton(icon: Icon(Icons.search, color: AppColors.darkText), onPressed: () {}),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
