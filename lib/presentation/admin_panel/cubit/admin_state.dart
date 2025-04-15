part of 'admin_cubit.dart';

sealed class AdminState {}

final class AdminInitial extends AdminState {}

class AddItemSuccess extends AdminState {
  final List<MenuObject> menuItems;

  AddItemSuccess({required this.menuItems});
}

class AddItemError extends AdminState {
  final String message;

  AddItemError({required this.message});
}
