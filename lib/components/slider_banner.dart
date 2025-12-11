import 'package:flutter/material.dart';

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
      height: 250,
      width: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blue.shade100,
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: TextStyle(fontSize: 30)),
                  Text(subTitle, style: TextStyle(fontSize: 22)),
                  Text(collection, style: TextStyle(fontSize: 18)),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: callback,
                    child: Text("Shop Now", style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.fitHeight,
                  height: double.infinity,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


