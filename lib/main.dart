import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/home/cubit/menu_cubit.dart';
import 'package:menu_app/presentation/home/views/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuCubit(),
      child: MaterialApp(
        home: const HomeView(),
        theme: ThemeData.dark(),
      ),
    );
  }
}
