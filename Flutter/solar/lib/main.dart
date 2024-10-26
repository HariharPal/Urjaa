import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar/core/notifier/current_user_notifier.dart';
import 'package:solar/features/auth/repository/auth_local_repository.dart';
import 'package:solar/features/auth/view/pages/login_page.dart';
import 'package:solar/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:solar/features/home/view/pages/homeScreen/splash_page.dart';
import 'package:solar/features/home/view/pages/nav_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(authLocalRepositoryProvider).init();
  final token = container.read(authLocalRepositoryProvider).getToken();
  print(token);
  if (token != null) {
    await container.read(authViewModelProvider.notifier).getData();
  }

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    print(currentUser);
    return MaterialApp(
      title: 'Solar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'poppins'),
          bodyMedium: TextStyle(fontFamily: 'roboto'),
        ),
      ),
      home: SplashPage(
        widget: currentUser == null ? const LoginPage() : const NavPage(),
      ),
    );
  }
}
