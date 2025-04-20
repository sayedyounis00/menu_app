import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/admin_panel/cubit/admin_cubit.dart';
import 'package:menu_app/presentation/admin_panel/view/widgets/admin_panel_view_body.dart';
import 'package:menu_app/presentation/auth/view/widgets/input_feild.dart';
import 'package:menu_app/presentation/home/data/menu_object.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminPanelView extends StatefulWidget {
  const AdminPanelView({super.key});

  @override
  State<AdminPanelView> createState() => _AdminPanelViewState();
}

class _AdminPanelViewState extends State<AdminPanelView> {
  int nextId = 1;
  final client = Supabase.instance.client;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    imageController.dispose();
    super.dispose();
  }
  
  void addMenuItem() {
    final newItem = MenuObject(
      id: nextId++,
      name: nameController.text,
      price: priceController.text,
      image: imageController.text,
      state: false,
    );
    BlocProvider.of<AdminCubit>(context).addNewMenuItem(newItem);

    nameController.clear();
    priceController.clear();
    imageController.clear();
  }

  void showAddItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Menu Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InputField(
                  label: 'Item Name',
                  icon: Icons.text_decrease,
                  controller: nameController,
                  validator: (val) {
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                InputField(
                    label: 'Price',
                    icon: Icons.price_change,
                    controller: priceController,
                    validator: (val) {
                      return null;
                    },
                    keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                InputField(
                    label: 'Image URL',
                    icon: Icons.image,
                    controller: imageController,
                    validator: (val) {
                      return null;
                    }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                addMenuItem();
                Navigator.of(context).pop();
              },
              child: const Text('Add Item'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Admin Panel'),
      ),
      body: const AdminPanelViewBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddItemDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
