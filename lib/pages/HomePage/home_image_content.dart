import 'package:flutter/material.dart';

class HomeImageContent extends StatelessWidget {
  final double width;
  final double height;

  const HomeImageContent({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context)
          .size
          .width, // Đặt width của Container bằng width của màn hình
      height: 250, // Đặt height cố định cho Container
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .secondary, // Đặt màu nền cho Container
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(8), // Đặt border radius cho ClipRRect
            child: Image.network(
              'https://images.unsplash.com/photo-1581897882013-a65d0976c93f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyfHx6b2RpYWN8ZW58MHx8fHwxNzE4MTgxNjM0fDA&ixlib=rb-4.0.3&q=80&w=1080',
              width: MediaQuery.of(context)
                  .size
                  .width, // Đặt width của Image bằng width của màn hình
              height: 250, // Đặt height cố định cho Image
              fit: BoxFit.cover, // Đặt BoxFit để hình ảnh phủ kín Container
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(0, 1),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary, // Đặt màu nền cho các chấm tròn
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
