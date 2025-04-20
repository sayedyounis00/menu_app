import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/admin_panel/data/repo/admin_repo.dart';
import 'package:menu_app/presentation/home/data/menu_object.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit(this.client) : super(AdminInitial());
  final SupabaseClient client;
  List<MenuObject> _menuItems = [];

  void getAllMenuItems() async {
    emit(AddItemLoading());
    try {
      _menuItems = await AdminRepository(client).getAllMenuItems();
      emit(AddItemSuccess(menuItems: _menuItems));
    } on SocketException catch (e) {
      emit(AddItemFailure(errMessage: e.toString()));
    }
  }

  void addNewMenuItem(MenuObject menuItem) async {
    try {
      AdminRepository(client).addMenuItem(menuItem);
      emit(AddItemSuccess(menuItems: _menuItems));
    } on SocketException catch (e) {
      emit(AddItemFailure(errMessage: e.toString()));
    }
  }

  void deleteItem(int id) async {
    try {
      AdminRepository(client).deleteMenuItem(id);
      emit(AddItemSuccess(menuItems: _menuItems));
    } on SocketException catch (e) {
      emit(AddItemFailure(errMessage: e.toString()));
    }
  }
}
