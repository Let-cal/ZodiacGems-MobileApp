import 'package:flutter/material.dart';

class ImageSection extends StatefulWidget {
  const ImageSection({super.key});

  @override
  _ImageSectionState get createState => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  int _currentIndex = 0;
  final List<String> _imageUrls = [
    'https://images.unsplash.com/photo-1640091777650-5706c3180d72?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw4fHx6b2RpYWN8ZW58MHx8fHwxNzE4MTgxNjM0fDA&ixlib=rb-4.0.3&q=80&w=1080',
    'https://images.unsplash.com/photo-1605100804763-247f67b3557e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxfHxyaW5nfGVufDB8fHx8MTcxODE5MDg4M3ww&ixlib=rb-4.0.3&q=80&w=1080',
    'https://images.unsplash.com/photo-1575936123452-b67c3203c357?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxfHxyaW5nfGVufDB8fHx8MTcxODE5MDg4M3ww&ixlib=rb-4.0.3&q=80&w=1080',
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxfHxyaW5nfGVufDB8fHx8MTcxODE5MDg4M3ww&ixlib=rb-4.0.3&q=80&w=1080'
  ];

  void _previousImage() {
    setState(() {
      _currentIndex = (_currentIndex - 1) % _imageUrls.length;
      if (_currentIndex < 0) {
        _currentIndex = _imageUrls.length - 1;
      }
    });
  }

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _imageUrls.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.network(
                _imageUrls[_currentIndex],
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 5,
              top: MediaQuery.of(context).size.height * 0.3 / 2 - 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousImage,
                color: Colors.white,
              ),
            ),
            Positioned(
              right: 5,
              top: MediaQuery.of(context).size.height * 0.3 / 2 - 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: _nextImage,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
