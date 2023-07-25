import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (value) => context.go("/home/$value"),
      elevation: 0,
      destinations: const [
        NavigationDestination(
          label: "Home",
          icon: Icon(Icons.home_max),
        ),
        NavigationDestination(
          label: "Categories",
          icon: Icon(Icons.label_outline_rounded),
        ),
        NavigationDestination(
          label: "Favoritos",
          icon: Icon(Icons.favorite_outline),
        ),
      ],
    );
  }
}
