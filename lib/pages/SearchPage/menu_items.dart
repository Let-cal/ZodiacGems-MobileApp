import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final String subtext;
  final String description;
  final String imageUrl;
  final String price;
  final Function(BuildContext, Map<String, dynamic>) onTap;

  const MenuItem({
    super.key,
    required this.title,
    required this.subtext,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(context, {
        'title': title,
        'subtext': subtext,
        'imageUrl': imageUrl,
        'description': description,
        'price': price,
      }),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 3,
                color: Color(0x411D2429),
                offset: Offset(0.0, 1),
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 1, 1),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 4, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: _buildFormattedSubtext(subtext),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF57636C),
                        size: 24,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 12, 4, 8),
                      child: Text(
                        price,
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormattedSubtext(String subtext) {
    final List<String> parts = subtext.split(', ');

    return parts.map((part) {
      final String label = part.split(': ')[0];
      final String value = part.split(': ')[1];

      Color color = _getChipColor(label);

      return Chip(
        label: Text(value),
        backgroundColor: color.withOpacity(0.1),
        labelStyle: TextStyle(color: color),
      );
    }).toList();
  }

  Color _getChipColor(String label) {
    switch (label) {
      case 'Quantity':
        return Colors.blue;
      case 'Category':
        return Colors.green;
      case 'Material':
        return Colors.orange;
      case 'Gender':
        return Colors.purple;
      case 'Zodiac':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
