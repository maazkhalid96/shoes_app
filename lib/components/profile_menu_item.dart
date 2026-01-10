import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final double? iconsSize;
  final double? textSize;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.iconsSize,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor, size: iconsSize ?? 24.h),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: textSize ?? 16.sp),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: (iconsSize ?? 24.h) * 0.8,

        color: Colors.white70,
      ),
      onTap: onTap,
    );
  }
}
