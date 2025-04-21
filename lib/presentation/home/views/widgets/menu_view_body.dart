import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/admin_panel/view/widgets/failure_screen.dart';
import 'package:menu_app/presentation/home/data/menu_object.dart';
import 'package:menu_app/presentation/home/menu/menu_cubit.dart';
import 'package:menu_app/presentation/home/views/widgets/menu_item.dart';

class MenuViewBody extends StatefulWidget {
  const MenuViewBody({super.key});

  @override
  State<MenuViewBody> createState() => _MenuViewBodyState();
}

class _MenuViewBodyState extends State<MenuViewBody> {
  @override
  void initState() {
    super.initState();
    // Load initial data when widget is created
    _loadMenuItems();
  }

  Future<void> _loadMenuItems() async {
    await BlocProvider.of<MenuCubit>(context).getAllMenuItems();
  }

  Future<void> _refreshMenu() async {
    await BlocProvider.of<MenuCubit>(context).getAllMenuItems();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MenuCubit, MenuState>(
      listener: (context, state) {
        if (state is MenuItemFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: RefreshIndicator(
        onRefresh: _refreshMenu,
        child: BlocBuilder<MenuCubit, MenuState>(
          builder: (context, state) {
            return _buildContent(state);
          },
        ),
      ),
    );
  }

  Widget _buildContent(MenuState state) {
    if (state is MenuItemLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is MenuItemLoaded) {
      return _buildMenuGrid(state.menuItems);
    } else if (state is MenuItemFailure) {
      return FailureScreen(
        errorMessage: state.errMessage,
        onRetry: _refreshMenu,
      );
    } else {
      // Initial state or unknown state
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildMenuGrid(List<MenuObject> menuItems) {
    if (menuItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fastfood, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No menu items available',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              onPressed: _refreshMenu,
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) => MenuItem(
        menuItem: menuItems[index],
      ),
    );
  }
}
