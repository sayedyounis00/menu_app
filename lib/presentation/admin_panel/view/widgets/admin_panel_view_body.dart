import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/admin_panel/cubit/admin_cubit.dart';
import 'package:menu_app/presentation/admin_panel/view/widgets/failure_screen.dart';
import 'package:menu_app/presentation/home/data/menu_object.dart';

class AdminPanelViewBody extends StatefulWidget {
  const AdminPanelViewBody({super.key});

  @override
  State<AdminPanelViewBody> createState() => _AdminPanelViewBodyState();
}

class _AdminPanelViewBodyState extends State<AdminPanelViewBody> {
  @override
  void initState() {
    super.initState();
    // Load data when widget initializes
    _loadMenuItems();
  }

  Future<void> _loadMenuItems() async {
    await BlocProvider.of<AdminCubit>(context).getAllMenuItems();
  }

  Future<void> _refreshData() async {
    await BlocProvider.of<AdminCubit>(context).getAllMenuItems();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminCubit, AdminState>(
      listener: (context, state) {
        if (state is AddItemFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: RefreshIndicator(
        onRefresh: _refreshData,
        child: BlocBuilder<AdminCubit, AdminState>(
          builder: (context, state) {
            return _buildContent(state);
          },
        ),
      ),
    );
  }

  Widget _buildContent(AdminState state) {
    if (state is AddItemLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is AddItemSuccess) {
      return _buildMenuList(state.menuItems);
    } else if (state is AddItemFailure) {
      return FailureScreen(
        onRetry: _refreshData,
        errorMessage: state.errMessage,
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildMenuList(List<MenuObject> menuItems) {
    if (menuItems.isEmpty) {
      return const Center(
        child: Text(
          'No menu items available',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final menuItem = menuItems[index];
        return _buildMenuItemCard(context, menuItem);
      },
    );
  }

  Widget _buildMenuItemCard(BuildContext context, MenuObject menuItem) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              menuItem.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.fastfood),
            ),
          ),
          title: Text(
            menuItem.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            "\$${menuItem.price}",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.green.shade700,
                ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showEditDialog(context, menuItem),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDelete(context, menuItem.id),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, MenuObject menuItem) {
    BlocProvider.of<AdminCubit>(context).showItemDialog(
      context: context,
      menuItem: menuItem,
    );
  }

  Future<void> _confirmDelete(BuildContext context, int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await BlocProvider.of<AdminCubit>(context).deleteItem(id);
    }
  }
}
