import 'dart:io';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const NavBar({
    super.key,
    required this.pageIndex, 
    required this.onTap,
    
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: Platform.isIOS ? 16 : 8,
      ),
      child: BottomAppBar(
        elevation: 8.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 60,
            color: Colors.lightBlue.shade700,
            child: Row(
              children: [
                navItem( //Home Button
                  Icons.home_filled,
                  pageIndex == 0,
                  onTap: () => onTap(0),
                ),
                navItem( //IoT Device Configuration Button
                  Icons.build_circle,
                  pageIndex == 1,
                  onTap: () => onTap(1),
                ),
                navItem( //History Button
                  Icons.drive_folder_upload_rounded,
                  pageIndex == 2,
                  onTap: () => onTap(2),
                ),
                navItem( //Account and Settings Button
                  Icons.settings_applications_sharp,
                  pageIndex == 3,
                  onTap: () => onTap(3),
                ),  
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget navItem(IconData icon, bool selected, {Function()? onTap}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: Icon(
        icon,
        color: selected ? Colors.white : Colors.white.withOpacity(0.8),
      )
    )
  );
}