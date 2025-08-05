import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(String)? onSearchChanged;

  const CustomAppBar({super.key, this.onSearchChanged});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}


class _CustomAppBarState extends State<CustomAppBar> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.lightBackground,
      automaticallyImplyLeading: false,
      leading: _isSearching
          ? IconButton(
        icon: Icon(Icons.close, color: AppColors.darkText),
        onPressed: () {
          setState(() {
            _isSearching = false;
            _searchController.clear();
          });
        },
      )
          : null,
      title: _isSearching
          ?TextField(
        controller: _searchController,
        autofocus: true,
        textDirection: TextDirection.rtl,
        decoration: const InputDecoration(
          hintText: 'ابحث...',
          hintTextDirection: TextDirection.rtl,
          border: InputBorder.none,
        ),
        style: TextStyle(color: AppColors.darkText, fontSize: 16),
        onChanged: widget.onSearchChanged,
      )

          : Text(
        'التصنيفات',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
        ),
      ),
      actions: !_isSearching
          ? [
        IconButton(
          icon: Icon(Icons.search, color: AppColors.darkText),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        ),
      ]
          : [],
      centerTitle: true,
    );

  }
}
