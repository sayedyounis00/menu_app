import 'package:flutter/material.dart';

class AdminPanelViewBody extends StatelessWidget {
  const AdminPanelViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8.0),
          elevation: 4.0,
          child: ListTile(
            leading: Image.asset("image"),
            title: const Text(""),
            subtitle: const Text(" EGP"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
                IconButton(icon: const Icon(Icons.delete), onPressed: () {}),
              ],
            ),
          ),
        );
      },
    );
  }
}
