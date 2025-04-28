import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:menu_app/presentation/home/data/menu_object.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
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

  Future<void> addCartItem(int id) async {
    await supabase.from('menu_Items').update({
      'addedToCart': true,
    }).eq('id', id);
  }

  Future<void> updateItemCount(int count, int id) async {
    await supabase.from('menu_Items').update({
      'count': count,
    }).eq('id', id);
  }

  Future<void> removeFromCart(int id) async {
    await supabase.from('menu_Items').update({
      'addedToCart': false,
    }).eq('id', id);
  }

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
  //Storage

  Future<String?> uploadImageFromGallery({String? customFileName}) async {
    try {
      // 2. Pick image from gallery
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024, // Optional: resize large images
        maxHeight: 1024, // Optional: resize large images
      );

      if (pickedFile == null) return null;

      // 3. Prepare file for upload
      final file = File(pickedFile.path);
      final fileBytes = await file.readAsBytes();
      final fileExtension = path.extension(file.path).toLowerCase();
      final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';

      // 4. Generate file path - organized by date
      final now = DateTime.now();
      final fileName =
          customFileName ?? '${now.millisecondsSinceEpoch}$fileExtension';
      final fullPath =
          'items/$fileName'; // "items" matches your bucket structure

      // 5. Upload to 'menuapp' bucket
      await Supabase.instance.client.storage.from('menuapp').uploadBinary(
            fullPath,
            fileBytes,
            fileOptions: FileOptions(
              contentType: mimeType,
              upsert: true, // Overwrite if file exists
            ),
          );

      // 6. Get public URL
      return Supabase.instance.client.storage
          .from('menuapp')
          .getPublicUrl(fullPath);
    } catch (e) {
      // Handle different error types
      if (e is StorageException) {
      }
      return null;
    }
  }
}
