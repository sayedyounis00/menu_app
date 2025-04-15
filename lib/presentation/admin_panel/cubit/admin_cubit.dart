import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/admin_panel/data/repo/admin_repo.dart';
import 'package:menu_app/presentation/home/data/menu_object.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit(this.client) : super(AdminInitial());
  final SupabaseClient client;
  final List<MenuObject> _menuItems = [];
  void addMenuItem(MenuObject item) {
    AdminRepository(client).addMenuItem(item);
    emit(AddItemSuccess(menuItems: _menuItems));
  }
  
}
