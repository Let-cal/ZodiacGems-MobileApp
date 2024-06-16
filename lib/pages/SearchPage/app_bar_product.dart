import 'package:flutter/material.dart';

class AppBarProduct extends StatefulWidget implements PreferredSizeWidget {
  final TabBar? tabBar;

  const AppBarProduct({super.key, this.tabBar});

  @override
  _AppBarProductState createState() => _AppBarProductState();

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (tabBar?.preferredSize.height ?? 0));
}

class _AppBarProductState extends State<AppBarProduct> {
  bool _isSearchActive = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: _isSearchActive
          ? const TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.black),
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
              print('Shopping cart icon pressed');
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
