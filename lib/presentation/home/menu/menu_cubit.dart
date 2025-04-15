import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/admin_panel/data/repo/admin_repo.dart';
import 'package:menu_app/presentation/home/data/menu_object.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit(this.client) : super(MenuInitial());
  final SupabaseClient client;
  int count = 0;
  List<MenuObject> menu = [];
  void getAllMenuItems() async {
    emit(MenuItemLoading());
    menu = await AdminRepository(client).getAllMenuItems();
    emit(MenuItemLoaded(menuItems: menu));
  }

  void addToCartAndUpdateCount(MenuObject menuItem) async {
    int count = menuItem.count++;
    if (menuItem.count == 0) {
      await AdminRepository(client)
          .addCartItemAndUpdateCount(count, menuItem.id);
    }
    await AdminRepository(client).addCartItemAndUpdateCount(count, menuItem.id);
    emit(MenuItemLoaded(menuItems: menu));
  }
}
