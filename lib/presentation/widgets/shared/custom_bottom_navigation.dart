import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      items: const [
        BottomNavigationBarItem(
          label: "Home",
          icon: Icon(Icons.home_max),
        ),
        BottomNavigationBarItem(
          label: "Categories",
          icon: Icon(Icons.label_outline_rounded),
        ),
        BottomNavigationBarItem(
          label: "Favoritos",
          icon: Icon(Icons.favorite_outline),
        ),
      ],
    );
  }
}
