import 'package:flutter/material.dart';

import '../../SearchPage/search_page.dart';

const zodiacs = {
  1: "Aries",
  2: "Taurus",
  3: "Gemini",
  4: "Cancer",
  5: "Leo",
  6: "Virgo",
  7: "Libra",
  8: "Scorpio",
  9: "Sagittarius",
  10: "Capricorn",
  11: "Aquarius",
  12: "Pisces",
};

class ProductFilter extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const ProductFilter({Key? key});

  @override
  _ProductFilterState get createState => _ProductFilterState();
}

class _ProductFilterState extends State<ProductFilter> {
  int _selectedIndex = -1; // Initial index, none selected

  void _onTabSelected(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index; // Update selected tab index
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchPage(
            initialTabIndex: index,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: zodiacs.length,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              isScrollable: true,
              onTap: _onTabSelected,
              tabs: zodiacs.entries.map((entry) {
                return Tab(text: entry.value);
              }).toList(),
            ),
          ),
          // Adding a fixed height container to prevent "Cannot hit test a render box with no size" error
        ],
      ),
    );
  }
}
