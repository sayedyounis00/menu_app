part of 'menu_cubit.dart';

sealed class MenuState {}

final class MenuInitial extends MenuState {}

final class MenuItemLoading extends MenuState {}

final class MenuItemLoaded extends MenuState {
  final List<MenuObject> menuItems;
  MenuItemLoaded({required this.menuItems});
}

final class MenuItemFailure extends MenuState {
  final String errMessage;
  MenuItemFailure({required this.errMessage});
}
