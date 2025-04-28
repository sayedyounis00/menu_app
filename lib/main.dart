import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/core/helper/block_screen_shot.dart';
import 'package:menu_app/presentation/admin_panel/cubit/admin_cubit.dart';
import 'package:menu_app/presentation/auth/all/login_register_cubit.dart';
import 'package:menu_app/presentation/auth/view/login_view.dart';
import 'package:menu_app/presentation/home/menu/menu_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NoScreenShot().enableScreenShot();
  await Supabase.initialize(
    url: 'https://phqawsgtnxrngovjgfwq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBocWF3c2d0bnhybmdvdmpnZndxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ3MjAwMTAsImV4cCI6MjA2MDI5NjAxMH0.UhY44H4-m0u9lbr7M95OMDF3UY2kBRMy09VMKmngRGY',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MenuCubit(supabase)..getAllMenuItems(),
        ),
        BlocProvider(
          create: (context) =>
              AuthntaCubit(supabase: supabase)..checkAuthStatus(),
        ),
        BlocProvider(
          create: (context) => AdminCubit()..getAllMenuItems(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const LoginView(),
        theme: ThemeData.dark(),
      ),
    );
  }
}
