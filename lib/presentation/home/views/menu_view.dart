import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/home/menu/menu_cubit.dart';
import 'package:menu_app/presentation/home/views/widgets/menu_view_body.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        BlocProvider.of<MenuCubit>(context).getAllMenuItems();
        return Future.delayed(const Duration(milliseconds: 500));
      },
      child: const Scaffold(
        body: MenuViewBody(),
      ),
    );
  }
}
