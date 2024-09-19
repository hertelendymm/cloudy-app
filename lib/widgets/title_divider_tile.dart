import 'package:flutter/material.dart';

class TitleDividerTile extends StatelessWidget {
  const TitleDividerTile({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 20.0,
                  fontFamily: 'Spartan MB',
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10.0),
          Container(
              width: double.infinity, height: 5, color: Colors.grey.shade400)
        ],
      ),
    );
  }
}
