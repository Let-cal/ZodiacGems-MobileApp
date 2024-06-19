import 'package:flutter/material.dart';

class InformationSectionWidget extends StatelessWidget {
  const InformationSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Information',
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.arrow_drop_down,
                  size: 24,
                  color: Colors.black,
                ),
                onPressed: () {
                  print('IconButton pressed ...');
                },
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 2,
          color: Color(0xFFCCCCCC),
        ),
        // Add more sections as needed
      ],
    );
  }
}
