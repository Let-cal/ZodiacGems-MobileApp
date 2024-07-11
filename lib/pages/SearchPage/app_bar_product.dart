import 'package:flutter/material.dart';

class AppBarProduct extends StatefulWidget implements PreferredSizeWidget {
  final TabBar? tabBar;
  final ValueChanged<String> onSearch; // Add callback for search input

  const AppBarProduct({super.key, this.tabBar, required this.onSearch});

  @override
  _AppBarProductState get createState => _AppBarProductState();

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (tabBar?.preferredSize.height ?? 0));
}

class _AppBarProductState extends State<AppBarProduct> {
  bool _isSearchActive = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: _isSearchActive
          ? TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: widget.onSearch, // Notify parent on input change
            )
          : const Text(
              'Order Now',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Playfair Display',
                letterSpacing: 0,
              ),
            ),
      actions: [
        IconButton(
          icon: Icon(
            _isSearchActive ? Icons.close : Icons.search,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              if (_isSearchActive) {
                _searchController.clear();
                widget.onSearch('');
              }
              _isSearchActive = !_isSearchActive;
            });
          },
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
          child: IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.black,
              size: 24,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/addCart');
            },
          ),
        ),
      ],
      centerTitle: false,
      elevation: 0,
      bottom: widget.tabBar,
    );
  }
}
