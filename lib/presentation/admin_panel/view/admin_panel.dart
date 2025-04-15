import 'package:flutter/material.dart';
import 'package:menu_app/presentation/admin_panel/view/widgets/admin_panel_view_body.dart';

class AdminPanelView extends StatelessWidget {
  const AdminPanelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: const AdminPanelViewBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
