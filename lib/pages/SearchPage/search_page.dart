import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../HomePage/NavBar/nav_bar.dart';
import '../ViewDetails/view_detail_product_widget.dart';
import './menu_items.dart';
import 'app_bar_product.dart';

const categories = {
  1: "Necklaces",
  2: "Bracelets",
  3: "Earrings",
  4: "Rings",
  5: "Tshirt",
};

const genders = {
  1: "Male",
  2: "Female",
  3: "Other",
};

const materials = {
  1: "Gold",
  2: "Emerald",
  3: "Diamonds",
};

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

class SearchPage extends StatefulWidget {
  final int initialTabIndex;

  const SearchPage({super.key, required this.initialTabIndex});

  @override
  _SearchPageState get createState => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  void _navigateToDetailView(
      BuildContext context, Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewDetailProductWidget(product: product),
      ),
    );
  }

  int _selectedIndex = 1; // Default to Search page
  bool _isCategoryPopupVisible = false;
  final Set<int> _selectedCategoryIds = {};
  String _searchQuery = '';

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final response = await http
        .get(Uri.parse('https://zodiacjewerly.azurewebsites.net/api/products'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((item) {
        String imageUrl = '';
        if (item['image-urls'] != null && item['image-urls'].isNotEmpty) {
          imageUrl = item['image-urls'][0];
        }
        return {
          'title': item['name-product'],
          'description-product': item['description-product'],
          'subtext':
              'Category: ${categories[item['category-id']]}, Material: ${materials[item['material-id']]}, Gender: ${genders[item['gender-id']]}, Zodiac: ${zodiacs[item['zodiac-id']]}',
          'imageUrl': imageUrl,
          'price': '\$${item['price']}',
          'zodiac-id': item['zodiac-id'],
          'category-id': item['category-id'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/cart');
        break;
      case 1:
        // No need to navigate to '/search' again if already on search page
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/about');
        break;
      default:
        break;
    }

    // Update selected index only if navigation occurs
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showCategoryPopup() {
    setState(() {
      _isCategoryPopupVisible = true;
    });
  }

  void _hideCategoryPopup() {
    setState(() {
      _isCategoryPopupVisible = false;
    });
  }

  Widget _buildCategoryPopup() {
    return GestureDetector(
      onTap: _hideCategoryPopup,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView(
              shrinkWrap: true,
              children: categories.entries.map((entry) {
                return ListTile(
                  title: Text(entry.value),
                  onTap: () {
                    setState(() {
                      _selectedCategoryIds.add(entry.key);
                      _hideCategoryPopup();
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  bool _matchesSearchQuery(String title) {
    return title.toLowerCase().contains(_searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.initialTabIndex,
      length: zodiacs.length,
      child: Scaffold(
        appBar: AppBarProduct(
          tabBar: TabBar(
            isScrollable: true,
            tabs: zodiacs.entries.map((entry) {
              return Tab(text: entry.value);
            }).toList(),
          ),
          onSearch: _handleSearch,
        ),
        body: Column(
          children: [
            if (_selectedCategoryIds.isNotEmpty)
              Wrap(
                spacing: 8.0,
                children: _selectedCategoryIds.map((id) {
                  return Chip(
                    label: Text(categories[id]!),
                    onDeleted: () {
                      setState(() {
                        _selectedCategoryIds.remove(id);
                      });
                    },
                  );
                }).toList(),
              ),
            Expanded(
              child: Stack(
                children: [
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: fetchProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No products found'));
                      } else {
                        final items = snapshot.data!;
                        final filteredItems = items
                            .where(
                                (item) => _matchesSearchQuery(item['title']!))
                            .toList();
                        return TabBarView(
                          children: zodiacs.keys.map((zodiacId) {
                            final zodiacFilteredItems = filteredItems
                                .where((item) =>
                                    item['zodiac-id'] == zodiacId &&
                                    (_selectedCategoryIds.isEmpty ||
                                        _selectedCategoryIds
                                            .contains(item['category-id'])))
                                .toList();
                            if (zodiacFilteredItems.isEmpty) {
                              return const Center(
                                child: Text(
                                  'No products found for selected category and zodiac.',
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }
                            return SingleChildScrollView(
                              child: Column(
                                children: zodiacFilteredItems.map((item) {
                                  return MenuItem(
                                    title: item['title']!,
                                    subtext: item['subtext']!,
                                    imageUrl: item['imageUrl']!,
                                    description: item['description-product']!,
                                    price: item['price']!,
                                    onTap: (ctx, prod) => _navigateToDetailView(
                                        ctx, prod), // Gọi hàm từ đây
                                  );
                                }).toList(),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                  if (_isCategoryPopupVisible) _buildCategoryPopup(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showCategoryPopup,
          child: const Icon(Icons.filter_list),
        ),
        bottomNavigationBar: NavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
