import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final String subtext;
  final String description;
  final String imageUrl;
  final String price;
  final int quantity; // Thêm quantity vào MenuItem

  final Function(BuildContext, Map<String, dynamic>) onTap;

  const MenuItem({
    Key? key,
    required this.title,
    required this.subtext,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.quantity,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: quantity > 0
          ? () => onTap(context, {
                'title': title,
                'subtext': subtext,
                'imageUrl': imageUrl,
                'description': description,
                'price': price,
              })
          : null, // Kiểm tra quantity trước khi gọi onTap
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: quantity > 0
                ? const Color(0xFFFFF5E1) // Màu sắc chủ đạo của cửa hàng
                : Colors.grey[300], // Màu sắc cho sản phẩm đã hết hàng
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        children: _buildFormattedSubtext(subtext),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: quantity > 0
                        ? const Icon(
                            Icons.chevron_right_rounded,
                            color: Color(0xFF57636C),
                            size: 24,
                          )
                        : const Text(
                            'Sold Out',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      price,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
        label: Text(
          value,
          style: TextStyle(
            color: color,
          ),
        ),
        backgroundColor: color.withOpacity(0.1),
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
