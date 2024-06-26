import 'package:flutter/material.dart';

import '../AppBar/all_app_bar.dart';
import 'CartItem.dart';
import 'PriceBreakdown.dart';
import 'cart_page_model.dart';

class CartPageWidget extends StatefulWidget {
  const CartPageWidget({super.key});

  @override
  State<CartPageWidget> get createState => _CartPageWidgetState();
}

class _CartPageWidgetState extends State<CartPageWidget> {
  late CartPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = CartPageModel(); // Khởi tạo model trực tiếp

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: const CustomAppBar(
          title: 'My Cart', // Truyền văn bản vào tham số title
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Text(
                        'Order Summary',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Column(
                      children: [
                        CartItem(
                          imageUrl: 'https://example.com/image1.jpg',
                          title: 'Controller',
                          price: 'Rs 5000',
                          quantity: '1',
                          onDelete: () {
                            print('Delete item 1');
                          },
                        ),
                        CartItem(
                          imageUrl: 'https://example.com/image2.jpg',
                          title: 'Play Station',
                          price: 'Rs 40000',
                          quantity: '1',
                          onDelete: () {
                            print('Delete item 2');
                          },
                        ),
                      ],
                    ),
                    Divider(
                      height: 32,
                      thickness: 2,
                      color: Theme.of(context).dividerColor,
                    ),
                    const PriceBreakdown(
                      basePrice: 'Rs 45000',
                      taxes: 'Rs 1000',
                      totalPrice: 'Rs 46000',
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                      child: ElevatedButton(
                        onPressed: () {
                          print('Button pressed ...');
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.black,
                        ),
                        child: const Text(
                          'Proceed to Checkout',
                          style: TextStyle(
                            color: Colors.white, // Màu chữ của button
                            fontSize: 16, // Thay đổi kích thước chữ nếu cần
                            fontWeight: FontWeight
                                .bold, // Thay đổi độ đậm của chữ nếu cần
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
