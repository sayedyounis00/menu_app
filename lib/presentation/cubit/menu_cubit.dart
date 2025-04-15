import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/data/menu_item.dart';
part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit() : super(MenuInitial());
  int count = 0;

  List<MenuObject> menu = [
    MenuObject(
        id: 1,
        name: "Pizza",
        price: "20",
        image: "assets/pizza_e.png",
        count: 0),
    MenuObject(
        id: 2,
        name: "Coffee",
        price: "40",
        image: "assets/coffe.png",
        count: 0),
    MenuObject(
        id: 3,
        name: "Cake",
        price: "10",
        image: "assets/cake_lice-.png",
        count: 0),
    MenuObject(
        id: 4, name: "Tea", price: "5", image: "assets/tea.png", count: 0),
    MenuObject(
        id: 5, name: "Rice", price: "30", image: "assets/rice.png", count: 0),
    MenuObject(
        id: 6,
        name: "Burger",
        price: "10",
        image: "assets/burger.png",
        count: 0),
  ];
  List<MenuObject> cartItems = [];

  void addToCart(MenuObject menuItem) {
    if (menuItem.count <= 0) {
      cartItems.add(menuItem);
    }
    menuItem.count++;
    emit(CartItemAdded());
  }

  void removeFromCart(int id, MenuObject menuItem) {
    menuItem.count--;
    if (menuItem.count == 0) {
      cartItems.removeAt(id);
    }
    emit(CartItemRemoved());
  }
}
