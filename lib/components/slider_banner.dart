import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SliderBanner extends StatelessWidget {
  final String title;
  final String subTitle;
  final String collection;
  final String imagePath;
  final VoidCallback callback;

  const SliderBanner({
    super.key,
    required this.title,
    required this.subTitle,
    required this.collection,
    required this.imagePath,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Colors.blue.shade100,
      ),
      child: Stack(
        children: [
          /// TEXT CONTENT
          Padding(
            padding:  EdgeInsets.all(20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
                ),
                Text(subTitle, style: TextStyle(fontSize: 20.sp)),
                 SizedBox(height: 5.h),
                Text(collection, style: TextStyle(fontSize: 16.sp)),
                SizedBox(height: 15.h),
                ElevatedButton(
                  onPressed: callback,
                  child: Text("Shop Now", style: TextStyle(fontSize: 16.sp),),
                ),
              ],
            ),
          ),

          Positioned(
            right:-10.w,
            bottom: 0,
            top: 0,
            child: Image.asset(
              imagePath,

              fit: BoxFit.contain, 
              height: 250.h,
              width: 250.w,
            ),
          ),
        ],
      ),
    );
  }
}
