import 'package:flutter/material.dart';

class AboutProfileWidget extends StatelessWidget {
  final String text;
  final bool isEdit;
  final String sectionName;
  final void Function()? onPressed;

  const AboutProfileWidget({
    super.key,
    required this.text,
    this.isEdit = false,
    required this.sectionName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(
        left: 15,
        bottom: 15,
      ),
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              isEdit
                  ? IconButton(
                      onPressed: onPressed,
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    )
                  : IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    ),
            ],
          ),
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
