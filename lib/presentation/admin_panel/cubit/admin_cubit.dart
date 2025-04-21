import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/core/widget/input_feild.dart';
import 'package:menu_app/presentation/admin_panel/data/repo/admin_repo.dart';
import 'package:menu_app/presentation/home/data/menu_object.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final SupabaseClient _client;
  final AdminRepository _repository;
  
  bool isLoaded = false;
  String imageUrl = '';
  int nextId = 0;
  
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  List<MenuObject> _menuItems = [];
  List<MenuObject> get menuItems => _menuItems;

  AdminCubit({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client,
        _repository = AdminRepository(client ?? Supabase.instance.client),
        super(AdminInitial());

  @override
  Future<void> close() {
    nameController.dispose();
    priceController.dispose();
    return super.close();
  }

  Future<void> getAllMenuItems() async {
    emit(AddItemLoading());
    try {
      _menuItems = await _repository.getAllMenuItems();
      _updateNextId();
      emit(AddItemSuccess(menuItems: _menuItems));
    } on SocketException catch (e) {
      emit(AddItemFailure(errMessage: 'Network error: ${e.message}'));
    } catch (e) {
      emit(AddItemFailure(errMessage: 'Failed to load menu items'));
      log('Error getting menu items: $e');
    }
  }

  Future<void> addNewMenuItem(MenuObject menuItem) async {
    try {
      await _repository.addMenuItem(menuItem);
      await getAllMenuItems();
    } on SocketException catch (e) {
      emit(AddItemFailure(errMessage: 'Network error: ${e.message}'));
    } catch (e) {
      emit(AddItemFailure(errMessage: 'Failed to add menu item'));
      log('Error adding menu item: $e');
    }
  }

  Future<void> editMenuItem(MenuObject menuItem) async {
    try {
      await _repository.updateMenuItem(menuItem);
      await getAllMenuItems();
    } on SocketException catch (e) {
      emit(AddItemFailure(errMessage: 'Network error: ${e.message}'));
    } catch (e) {
      emit(AddItemFailure(errMessage: 'Failed to update menu item'));
      log('Error updating menu item: $e');
    }
  }

  Future<void> deleteItem(int id) async {
    try {
      await _repository.deleteMenuItem(id);
      await getAllMenuItems();
    } on SocketException catch (e) {
      emit(AddItemFailure(errMessage: 'Network error: ${e.message}'));
    } catch (e) {
      emit(AddItemFailure(errMessage: 'Failed to delete menu item'));
      log('Error deleting menu item: $e');
    }
  }

  void _updateNextId() {
    if (_menuItems.isEmpty) {
      nextId = 0;
    } else {
      nextId = _menuItems.map((item) => item.id).reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  Future<void> showItemDialog({
    required BuildContext context,
    MenuObject? menuItem,
  }) async {
    // Initialize controllers
    if (menuItem != null) {
      nameController.text = menuItem.name;
      priceController.text = menuItem.price;
      imageUrl = menuItem.image;
      isLoaded = menuItem.image.isNotEmpty;
    } else {
      nameController.clear();
      priceController.clear();
      imageUrl = "";
      isLoaded = false;
    }

    bool isFormValid() {
      return _formKey.currentState?.validate() == true && isLoaded;
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                  menuItem == null ? 'Add New Menu Item' : 'Edit Menu Item'),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InputField(
                        label: 'Item Name',
                        icon: Icons.text_decrease,
                        controller: nameController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please enter item name';
                          }
                          return null;
                        },
                        onChange: (p0) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        label: 'Price',
                        icon: Icons.price_change,
                        controller: priceController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please enter item price';
                          }
                          if (double.tryParse(val) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        onChange: (p0) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              final url = await AdminRepository(_client)
                                  .uploadImageFromGallery();
                              setState(() {
                                imageUrl = url ?? "";
                                isLoaded = url != null && url.isNotEmpty;
                              });
                              log(imageUrl);
                            },
                            icon: const Icon(Icons.add_a_photo),
                          ),
                          const SizedBox(width: 8),
                          if (isLoaded)
                            const Text("Image uploaded",
                                style: TextStyle(color: Colors.green))
                          else
                            const Text("Image required",
                                style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ],
                  ),
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
                  onPressed: isFormValid()
                      ? () {
                          emit(AddItemLoading());
                          if (_formKey.currentState!.validate()) {
                            if (menuItem == null) {
                              final newItem = MenuObject(
                                id: nextId++,
                                name: nameController.text,
                                price: priceController.text,
                                image: imageUrl,
                                state: false,
                              );
                              BlocProvider.of<AdminCubit>(context)
                                  .addNewMenuItem(newItem);
                            } else {
                              final updatedItem = menuItem.copyWith(
                                name: nameController.text,
                                price: priceController.text,
                                image: imageUrl,
                              );
                              BlocProvider.of<AdminCubit>(context)
                                  .editMenuItem(updatedItem);
                            }
                            emit(AddItemSuccess(menuItems: menuItems));
                            Navigator.of(context).pop();
                          }
                        }
                      : null,
                  child: Text(menuItem == null ? 'Add Item' : 'Update Item'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
