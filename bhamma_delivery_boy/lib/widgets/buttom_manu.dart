import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../utils/default_colors.dart';

class BottomMenu extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onClicked;

  const BottomMenu(
      {super.key, required this.selectedIndex, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDarkMode ? Colors.white : DefaultColor.mainColor;

    return Container(
      decoration: BoxDecoration(
        color: DefaultColor.white,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade400,
            offset: const Offset(0, 1),
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.search),
            //   label: 'Search',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: 'Order',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: iconColor,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
          onTap: (index) {
            // onClicked(index); // Update selected index

            if (index != selectedIndex)
              switch (index) {
                case 0:
                  onClicked;
                  Navigator.pushNamed(context, "/home");
                  break;
                // case 1:
                //   onClicked;
                //   Navigator.push(
                //     context,
                //     PageTransition(
                //       type: PageTransitionType.bottomToTop,
                //       child: const SearchScreen(),
                //       duration: const Duration(milliseconds: 150),
                //     ),
                //   );
                //   break;
                case 1:
                  onClicked;
                  Navigator.pushNamed(context, "/order");
                  break;
                case 2:
                  onClicked;
                  Navigator.pushNamed(context, "/profile");
                  break;
              }
          },
        ),
      ),
    );
  }
}
