import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/admin_panel/data/repo/admin_repo.dart';
import 'package:menu_app/presentation/home/data/menu_object.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final AdminRepository _repository;
  List<MenuObject> _menuItems = [];
  int _totalCount = 0;

  MenuCubit(SupabaseClient client)
      : _repository = AdminRepository(client),
        super(MenuInitial());

  List<MenuObject> get menuItems => _menuItems;
  int get totalCount => _totalCount;

  Future<void> getAllMenuItems() async {
    emit(MenuItemLoading());
    try {
      _menuItems = await _repository.getAllMenuItems();
      _updateTotalCount();
      emit(MenuItemLoaded(menuItems: _menuItems));
    } on SocketException catch (e) {
      emit(MenuItemFailure(errMessage: 'Network error: ${e.message}'));
    } catch (e) {
      emit(MenuItemFailure(errMessage: 'Failed to load menu items'));
    }
  }

  Future<void> addToCartAndUpdateCount(MenuObject menuItem) async {
    try {
      // Update local state immediately for responsive UI
      final updatedItem = menuItem.copyWith(count: menuItem.count + 1);
      _updateMenuItem(updatedItem);
      _totalCount++;

      // Perform API operations
      if (menuItem.count == 0) {
        await _repository.addCartItem(menuItem.id);
      }
      await _repository.updateItemCount(updatedItem.count, menuItem.id);

      emit(MenuItemLoaded(menuItems: _menuItems));
    } catch (e) {
      // Revert changes if API call fails
      _updateMenuItem(menuItem);
      _totalCount--;
      emit(MenuItemFailure(errMessage: 'Failed to update cart'));
    }
  }

  void _updateMenuItem(MenuObject updatedItem) {
    final index = _menuItems.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _menuItems[index] = updatedItem;
    }
  }

  void _updateTotalCount() {
    _totalCount = _menuItems.fold(0, (sum, item) => sum + item.count);
  }

  @override
  Future<void> close() {
    // Clean up resources if needed
    return super.close();
  }
}
