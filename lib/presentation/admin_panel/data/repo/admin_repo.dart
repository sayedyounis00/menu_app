import 'package:menu_app/presentation/home/data/menu_object.dart';
import 'package:menu_app/presentation/home/views/widgets/menu_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminRepository {
  final SupabaseClient supabase;

  AdminRepository(this.supabase);

  // Create
  Future<void> addMenuItem(MenuObject item) async {
    await supabase.from('menu_Items').insert({
      'id': item.id,
      'name': item.name,
      'price': item.price,
      'image': item.image,
      'count': item.count,
    });
  }

  Future<void> addCartItemAndUpdateCount(int count,int id) async {
    await supabase.from('menu_Items').update({
      'count': count,
      'addedToCart': true,
    }).eq('id',id);

  }

  // Read all
  Future<List<MenuObject>> getAllMenuItems() async {
    final response = await supabase.from('menu_Items').select();
    return (response as List)
        .map((item) => MenuObject(
              id: item['id'],
              name: item['name'],
              price: item['price'],
              image: item['image'],
              count: item['count'] ?? 0,
              state: item['addedToCart'] ?? false,
            ))
        .toList();
  }

  Future<List<MenuObject>> getAllCartItems() async {
    final response =
        await supabase.from('menu_Items').select().eq('addedToCart', true);
    return (response as List)
        .map((item) => MenuObject(
              id: item['id'],
              name: item['name'],
              price: item['price'],
              image: item['image'],
              count: item['count'] ?? 0,
              state: item['addedToCart'] ?? false,
            ))
        .toList();
  }

  // Update
  Future<void> updateMenuItem(MenuObject item) async {
    await supabase.from('menu_Items').update({
      'name': item.name,
      'price': item.price,
      'image': item.image,
    }).eq('id', item.id);
  }

  Future<void> updateItemCountAndState(
      {int? count, required int id, required bool state}) async {
    await supabase.from('menu_Items').update({
      'count': count,
      'addedToCart': state,
    }).eq('id', id);
  }

  // Delete
  Future<void> deleteMenuItem(int id) async {
    await supabase.from('menu_Items').delete().eq('id', id);
  }

  // Stream for real-time updates
  Stream<List<MenuObject>> getMenuItemsStream() {
    return supabase
        .from('menu_Items')
        .stream(primaryKey: ['id']).map((data) => data
            .map((item) => MenuObject(
                  id: item['id'],
                  name: item['name'],
                  price: item['price'],
                  image: item['image'],
                  count: item['count'] ?? 0,
                  state: item['addedToCart'] ?? false,
                ))
            .toList());
  }
}
