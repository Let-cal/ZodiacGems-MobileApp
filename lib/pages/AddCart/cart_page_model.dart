import 'package:flutter/material.dart';

class CartPageModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
  }
}
