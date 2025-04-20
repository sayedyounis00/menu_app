part of 'admin_cubit.dart';

sealed class AdminState {}

final class AdminInitial extends AdminState {}

final class AddItemLoading extends AdminState {}

class AddItemSuccess extends AdminState {
  final List<MenuObject> menuItems;
  AddItemSuccess({required this.menuItems});
}

class AddItemFailure extends AdminState {
  final String errMessage;
  AddItemFailure({required this.errMessage});
}
