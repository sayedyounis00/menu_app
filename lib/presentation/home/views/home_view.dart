import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/home/menu/menu_cubit.dart';
import 'package:menu_app/presentation/home/views/cart_view.dart';
import 'package:menu_app/presentation/home/views/menu_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const MenuView(),
    const CartView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              BlocProvider.of<MenuCubit>(context).getAllMenuItems();
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Menu"),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined), label: "Cart"),
          ]),
      appBar: AppBar(
        title: const Text(
          "Menu App",
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: _pages[_currentIndex],
    );
  }
}
