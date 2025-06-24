import 'package:flutter/material.dart';

class OffcanvasNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [DrawerHeader(child: Text('Menu')), ListTile(title: Text('Item 1'))],
      ),
    );
  }
}