import 'package:flutter/material.dart';

import '../AppBar/all_app_bar.dart'; // Import your CustomAppBar
import 'information_section_widget.dart'; // Import the model file
import 'product_details_widget.dart'; // Import your ProductDetailsWidget
import 'product_image_widget.dart'; // Import your ProductImageWidget
import 'similar_products_widget.dart';
import 'view_detail_product_model.dart'; // Import the model file

class ViewDetailProductWidget extends StatefulWidget {
  final Map<String, dynamic>? product;

  const ViewDetailProductWidget({super.key, this.product});

  @override
  _ViewDetailProductWidgetState get createState =>
      _ViewDetailProductWidgetState();
}

class _ViewDetailProductWidgetState extends State<ViewDetailProductWidget> {
  late ViewDetailProductModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ViewDetailProductModel());
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
      onTap: () {
        if (_model.unfocusNode.canRequestFocus) {
          FocusScope.of(context).requestFocus(_model.unfocusNode);
        } else {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F4F8),
        appBar: const CustomAppBar(
          title: 'My Cart', // Truyền văn bản vào tham số title
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Widget
              ProductImageWidget(imageUrl: widget.product!['imageUrl'] ?? ''),
              // Product Details Widget
              ProductDetailsWidget(
                  title: widget.product!['title'] ?? 'Name of product',
                  price: widget.product!['price'] ?? '\$500.00',
                  description: widget.product!['description']),
              // Information Section Widget
              // Assuming you have an InformationSectionWidget
              const InformationSectionWidget(),
              // Similar Products Widget
              const SimilarProductsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
