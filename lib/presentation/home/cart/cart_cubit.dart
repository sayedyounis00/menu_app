import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/admin_panel/data/repo/admin_repo.dart';
import 'package:menu_app/presentation/home/data/menu_object.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final AdminRepository _repository;
  List<MenuObject> _cartItems = [];
  int _totalItems = 0;

  CartCubit(SupabaseClient client)
      : _repository = AdminRepository(client),
        super(CartInitial());

  List<MenuObject> get cartItems => _cartItems;
  int get totalItems => _totalItems;

  Future<void> getAllCartItems() async {
    emit(CartLoading());
    try {
      _cartItems = await _repository.getAllCartItems();
      _updateTotalCount();
      emit(CartLoaded(cartItems: _cartItems));
    } on SocketException catch (e) {
      emit(CartError(errMessage: 'Network error: ${e.message}'));
    } catch (e) {
      emit(CartError(errMessage: 'Failed to load cart items'));
    }
  }

  Future<void> removeFromCartAndUpdateCount(int id, MenuObject menuItem) async {
    try {
      // Update local state immediately for responsive UI
      final updatedCount = menuItem.count - 1;
      _updateCartItem(id, updatedCount);
      
      // Update in repository
      await _repository.updateItemCount(updatedCount, id);
      
      if (updatedCount <= 0) {
        await _repository.removeFromCart(id);
        await getAllCartItems(); // Refresh the list
      } else {
        emit(CartLoaded(cartItems: _cartItems));
      }
    } catch (e) {
      // Revert changes if API call fails
      _updateCartItem(id, menuItem.count);
      emit(CartError(errMessage: 'Failed to update cart'));
    }
  }

  void _updateCartItem(int id, int newCount) {
    final index = _cartItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(count: newCount);
      _updateTotalCount();
    }
  }

  void _updateTotalCount() {
    _totalItems = _cartItems.fold(0, (sum, item) => sum + item.count);
  }

  @override
  Future<void> close() {
    // Clean up resources if needed
    return super.close();
  }
}