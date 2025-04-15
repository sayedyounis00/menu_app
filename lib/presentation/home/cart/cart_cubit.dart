import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:menu_app/presentation/admin_panel/data/repo/admin_repo.dart';
import 'package:menu_app/presentation/home/data/menu_object.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this.client) : super(CartInitial());
  final SupabaseClient client;
  List<MenuObject> cartItems = [];

  void getAllCartItems() async {
    emit(CartItemLoading());
    cartItems = await AdminRepository(client).getAllCartItems();
    emit(CartItemLoaded(cartItems: cartItems));
  }

  void removeFromCartAndUpdateCount(int id, MenuObject menuItem) {
    AdminRepository(client).updateItemCountAndState(
      count: menuItem.count--,
      id: menuItem.id,
      state: false,
    );
    if (menuItem.count == 0) {
      AdminRepository(client).updateItemCountAndState(
        count: menuItem.count,
        id: menuItem.id,
        state: false,
      );
    }
    emit(CartItemLoaded(cartItems: cartItems));
  }
}
