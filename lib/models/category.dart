import 'package:flutter/material.dart';

class Category {
  const Category({
    required this.id,
    required this.title,
    // required this.icon,
    this.color = Colors.orange,
  });

  final String id;
  final String title;
  // final String icon;
  final Color color;
}
