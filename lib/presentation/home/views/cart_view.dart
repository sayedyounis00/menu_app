import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/home/cart/cart_cubit.dart';
import 'package:menu_app/presentation/home/views/widgets/cart_view_body.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;
    return BlocProvider(
      create: (context) => CartCubit(client)..getAllCartItems(),
      child: const Scaffold(body: CartViewBody()),
    );
  }
}
