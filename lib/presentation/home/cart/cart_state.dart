part of 'cart_cubit.dart';

sealed class CartState {}

final class CartInitial extends CartState {}

final class CartItemLoading extends CartState {}

final class CartItemLoaded extends CartState {
  final List<MenuObject> cartItems;
  CartItemLoaded({required this.cartItems});
}

final class CartError extends CartState {
  final String errMessage;

  CartError({required this.errMessage});
}
