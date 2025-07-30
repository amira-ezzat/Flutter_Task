import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class BottomCartBar extends StatelessWidget {
  final double total;

  const BottomCartBar({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Icon(Icons.arrow_back_ios, color: Colors.white),
            Text('عرض السلة', style: TextStyle(fontSize: 18, color: Colors.white)),
          ]),
          Row(children: [
            Text(
              total.toStringAsFixed(2),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
            ),
            Text(' SAR', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white)),
          ]),
        ],
      ),
    );
  }
}
