part of 'menu_cubit.dart';

sealed class MenuState {}

final class MenuInitial extends MenuState {}
final class CartItemAdded extends MenuState {}
final class CartItemRemoved extends MenuState {}
