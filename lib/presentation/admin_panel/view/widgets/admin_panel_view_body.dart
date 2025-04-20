import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/admin_panel/cubit/admin_cubit.dart';
import 'package:menu_app/presentation/admin_panel/view/widgets/failure_screen.dart';

class AdminPanelViewBody extends StatelessWidget {
  const AdminPanelViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        BlocProvider.of<AdminCubit>(context).getAllMenuItems();
        return Future.delayed(const Duration(milliseconds: 500));
      },
      child: BlocBuilder<AdminCubit, AdminState>(
        builder: (context, state) {
          if (state is AddItemSuccess) {
            return ListView.builder(
              itemCount: state.menuItems.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 4.0,
                  child: ListTile(
                    leading: Image.asset(state.menuItems[index].image),
                    title: Text(state.menuItems[index].name),
                    subtitle: Text("${state.menuItems[index].price} \$"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.edit), onPressed: () {}),
                        IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              BlocProvider.of<AdminCubit>(context)
                                  .deleteItem(state.menuItems[index].id);
                            }),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is AddItemFailure) {
            return FailureScreen(
              onPressed: () {
                BlocProvider.of<AdminCubit>(context).getAllMenuItems();
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
