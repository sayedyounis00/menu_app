import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/home/menu/menu_cubit.dart';
import 'package:menu_app/presentation/home/views/widgets/menu_item.dart';

class MenuViewBody extends StatelessWidget {
  const MenuViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuCubit, MenuState>(
      builder: (context, state) {
        if (state is MenuItemLoaded) {
          return GridView.builder(
            itemCount: state.menuItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) => MenuItem(
              menuItem: state.menuItems[index],
            ),
          );
        } else if (state is MenuItemLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Text("Error");
        }
      },
    );
  }
}
