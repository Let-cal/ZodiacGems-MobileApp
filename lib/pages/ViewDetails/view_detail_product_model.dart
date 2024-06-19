import 'package:flutter/material.dart';

class ViewDetailProductModel {
  // Add properties and methods as needed
  late FocusNode unfocusNode;

  ViewDetailProductModel() {
    unfocusNode = FocusNode();
  }

  void dispose() {
    unfocusNode.dispose();
  }
}

ViewDetailProductModel createModel(
    BuildContext context, Function() modelCreator) {
  return modelCreator() as ViewDetailProductModel;
}
