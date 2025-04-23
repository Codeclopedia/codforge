import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/navigation_provider.dart';
import '../screens/home/view/home_screen.dart';
import '../screens/cart/view/cart_screen.dart';
import '../screens/category/view/category_screen.dart';
import '../screens/profile/view/profile_screen.dart';
import '../screens/settings/view/settings_screen.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    final screens = [
      const HomeScreen(),
      const CartScreen(),
      const CategoryScreen(),
      const ProfileScreen(),
      const SettingsScreen(),
    ];

    final screensName = ['Home', 'Cart', 'Category', 'Profile', 'Settings'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        leading: IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.white),
              shape: WidgetStateProperty.all(const CircleBorder()),
            ),
            onPressed: () {
              ref.read(bottomNavIndexProvider.notifier).state = 0;
            },
            icon: Icon(Icons.arrow_back_ios_outlined)),
        title: Text(screensName[currentIndex]),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none))
        ],
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 12,
        currentIndex: currentIndex,
        onTap: (index) =>
            ref.read(bottomNavIndexProvider.notifier).state = index,

        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed, // prevent shifting
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        items: [
          _buildBarItem(icon: Icons.home, isSelected: currentIndex == 0),
          _buildBarItem(
              icon: Icons.shopping_cart, isSelected: currentIndex == 1),
          _buildBarItem(
              icon: Icons.shopping_bag_rounded,
              isSelected: currentIndex == 2,
              currentIndex: currentIndex),
          _buildBarItem(icon: Icons.person, isSelected: currentIndex == 3),
          _buildBarItem(icon: Icons.settings, isSelected: currentIndex == 4),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildBarItem(
      {required IconData icon,
      required bool isSelected,
      int? currentIndex = 0}) {
    return BottomNavigationBarItem(
      label: "",
      icon: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: isSelected
                ? BoxDecoration(
                    color: Colors.green[900],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white),
                  )
                : null,
            child: Icon(
              icon,
              size: 25, // fixed size
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          if (isSelected && currentIndex == 2)
            Positioned(
              right: 0,
              top: -6,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    shape: BoxShape.circle,
                    color: Colors.green[900]),
                child: Text(
                  '2',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
