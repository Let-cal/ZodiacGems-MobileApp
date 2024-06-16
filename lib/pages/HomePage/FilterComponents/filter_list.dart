import 'package:flutter/material.dart';

class FilterList extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onClose;

  const FilterList({super.key, required this.isVisible, required this.onClose});

  @override
  _FilterListState createState() => _FilterListState();
}

class _FilterListState extends State<FilterList> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: widget.isVisible ? MediaQuery.of(context).size.height : 0,
      width: MediaQuery.of(context).size.width,
      color: Colors.black.withOpacity(0.5),
      child: GestureDetector(
        onTap: widget.onClose,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...['Ring', 'Earring', 'Necklace', 'Shirt', 'Bracelet']
                    .map((item) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        item,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
