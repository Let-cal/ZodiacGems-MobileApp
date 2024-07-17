import 'package:flutter/material.dart';

class ImageSection extends StatefulWidget {
  final List<dynamic> products;

  const ImageSection({super.key, required this.products});

  @override
  _ImageSectionState get createState => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  int _currentIndex = 0;

  void _previousImage() {
    setState(() {
      _currentIndex = (_currentIndex - 1) % widget.products.length;
      if (_currentIndex < 0) {
        _currentIndex = widget.products.length - 1;
      }
    });
  }

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.products.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) {
      return const Center(child: Text('No products available'));
    }

    final product = widget.products[_currentIndex];
    final imageUrl = product['image-urls'][0];
    final productName = product['name-product'];
    final price = product['price'];

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Text(
                productName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Text(
                '\$$price',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              left: 15,
              top: MediaQuery.of(context).size.height * 0.3 / 2 - 20,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: _previousImage,
                iconSize: 36,
              ),
            ),
            Positioned(
              right: 15,
              top: MediaQuery.of(context).size.height * 0.3 / 2 - 20,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                ),
                onPressed: _nextImage,
                iconSize: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
