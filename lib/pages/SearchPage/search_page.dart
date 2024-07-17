import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../NavBar/nav_bar.dart';
import '../ViewDetails/view_detail_product_widget.dart';
import '../url_API/constants.dart';
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
  int _currentPage = 1; // Track current page
  final int _pageSize = ApiConstants.defaultPageSize; // Default page size
  Future<List<Map<String, dynamic>>> fetchProducts(
      int page, int pageSize) async {
    final String getProductUrl =
        '${ApiConstants.getProductEndpoint}?page=$page&pageSize=$pageSize';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(getProductUrl),
      headers: <String, String>{
        'accept': '/',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      // Ensure 'data' contains 'list-data' as List<dynamic>
      if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {
        final Map<String, dynamic> dataMap = data['data'];
        if (dataMap.containsKey('list-data') &&
            dataMap['list-data'] is List<dynamic>) {
          final List<dynamic> dataList = dataMap['list-data'];
          return dataList.map((item) {
            String imageUrl = '';
            if (item['image-urls'] != null && item['image-urls'].isNotEmpty) {
              imageUrl = item['image-urls'][0];
            }
            return {
              'id': item['id'],
              'title': item['name-product'],
              'description-product': item['description-product'],
              'quantity': item['quantity'],
              'subtext':
                  'Category: ${categories[item['category-id']]}, Material: ${materials[item['material-id']]}, Gender: ${genders[item['gender-id']]}, Zodiac: ${zodiacs[item['zodiac-id']]}',
              'imageUrl': imageUrl,
              'price': '\$${item['price']}',
              'zodiac-id': item['zodiac-id'],
              'category-id': item['category-id'],
            };
          }).toList();
        } else {
          throw Exception(
              'Invalid products data format: list-data is not a List<dynamic>.');
        }
      } else {
        throw Exception(
            'Invalid products data format: data is not a Map<String, dynamic>.');
      }
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/addCart');
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
                    future: fetchProducts(_currentPage, _pageSize),
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
                        return Column(
                          children: [
                            Expanded(
                              child: TabBarView(
                                children: zodiacs.keys.map((zodiacId) {
                                  final zodiacFilteredItems = filteredItems
                                      .where((item) =>
                                          item['zodiac-id'] == zodiacId &&
                                          (_selectedCategoryIds.isEmpty ||
                                              _selectedCategoryIds.contains(
                                                  item['category-id'])))
                                      .toList();
                                  if (zodiacFilteredItems.isEmpty) {
                                    return const Center(
                                      child: Text(
                                        'No products found for selected category and zodiac.',
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  }
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        top:
                                            40.0), // Khoảng cách dưới giữa các Tab
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children:
                                            zodiacFilteredItems.map((item) {
                                          return MenuItem(
                                            title: item['title']!,
                                            subtext: item['subtext']!,
                                            imageUrl: item['imageUrl']!,
                                            quantity: item['quantity']!,
                                            description:
                                                item['description-product']!,
                                            price: item['price']!,
                                            onTap: (ctx, prod) =>
                                                _navigateToDetailView(ctx, {
                                              'title': item['title'],
                                              'description-product':
                                                  item['description-product'],
                                              'subtext': item['subtext'],
                                              'imageUrl': item['imageUrl'],
                                              'price': item['price'],
                                              'zodiac-id': item['zodiac-id'],
                                              'id': item['id'],
                                            }),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  _buildPaginationControls(), // Pagination controls
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

  Widget _buildPaginationControls() {
    return Container(
      margin: const EdgeInsets.only(
          bottom:
              16.0), // Khoảng cách dưới là 16.0 điểm ảnh, bạn có thể điều chỉnh theo ý muốn
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (_currentPage > 1) {
                setState(() {
                  _currentPage--;
                });
              }
            },
          ),
          Text('Page $_currentPage'),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              setState(() {
                _currentPage++;
              });
            },
          ),
        ],
      ),
    );
  }
}
