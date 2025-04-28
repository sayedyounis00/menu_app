import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/admin_panel/cubit/admin_cubit.dart';
import 'package:menu_app/presentation/admin_panel/view/widgets/admin_panel_view_body.dart';

class AdminPanelView extends StatefulWidget {
  const AdminPanelView({super.key});

  @override
  State<AdminPanelView> createState() => _AdminPanelViewState();
}

class _AdminPanelViewState extends State<AdminPanelView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const AdminPanelViewBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BlocProvider.of<AdminCubit>(context).showItemDialog(context: context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
