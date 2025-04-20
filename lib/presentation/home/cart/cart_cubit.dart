import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/admin_panel/data/repo/admin_repo.dart';
import 'package:menu_app/presentation/home/data/menu_object.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this.client) : super(CartInitial());

  int count = 0;
  final SupabaseClient client;
  List<MenuObject> cartItems = [];

  void getAllCartItems() async {
    emit(CartItemLoading());
    try {
      cartItems = await AdminRepository(client).getAllCartItems();
      emit(CartItemLoaded(cartItems: cartItems));
    } on SocketException catch (e) {
      emit(CartError(errMessage: e.toString()));
    }
  }

  void removeFromCartAndUpdateCount(int id, MenuObject menuItem) {
    count = --menuItem.count;
    AdminRepository(client).updateItemCount(count, id);
    if (menuItem.count == 0) {
      AdminRepository(client).removeFromCart(id);
    }
    emit(CartItemLoaded(cartItems: cartItems));
  }
}
