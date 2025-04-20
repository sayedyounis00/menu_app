import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/admin_panel/data/repo/admin_repo.dart';
import 'package:menu_app/presentation/home/data/menu_object.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit(this.client) : super(MenuInitial());
  int count = 0;
  List<MenuObject> menu = [];
  final SupabaseClient client;
  //! el king
  void getAllMenuItems() async {
    emit(MenuItemLoading());
    try {
      menu = await AdminRepository(client).getAllMenuItems();
      emit(MenuItemLoaded(menuItems: menu));
    } on SocketException catch (e) {
      emit(MenuItemFailure(errMessage: e.toString()));
    }
  }

  void addToCartAndUpdateCount(MenuObject menuItem) async {
    if (menuItem.count == 0) {
      await AdminRepository(client).addCartItem(menuItem.id);
    }
    count = ++menuItem.count;
    Future.delayed(const Duration(milliseconds: 500)).then(
      (value) => AdminRepository(client).updateItemCount(count, menuItem.id),
    );
    emit(MenuItemLoaded(menuItems: menu));
  }
}
