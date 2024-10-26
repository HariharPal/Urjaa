import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar/core/theme/app_pallete.dart';
import 'package:solar/core/widget/utils.dart';
import 'package:solar/features/auth/view/pages/login_page.dart';
import 'package:solar/features/auth/view/widgets/auth_button.dart';
import 'package:solar/features/auth/view/widgets/auth_textfield.dart';
import 'package:solar/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:solar/features/home/view/pages/nav_page.dart';

class SignupPage extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignupPage());
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(authViewModelProvider.select((val) => val?.isLoading == true));

    ref.listen(
      authViewModelProvider,
      (_, next) {
        next?.when(
          data: (data) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const NavPage(),
              ),
              (_) => false,
            );
          },
          error: (error, st) {
            showToast(context,
                content: error.toString(), type: ToastType.warning);
          },
          loading: () {},
        );
      },
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formkey,
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                    child: const Center(//SVG
                        ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Kickstart your green Investments",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Palette.textColor,
                        ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Column(
                              children: [
                                AuthTextfield(
                                  hintText: "Name",
                                  controller: _nameController,
                                ),
                                const SizedBox(height: 20),
                                AuthTextfield(
                                  hintText: "Email",
                                  controller: _emailController,
                                ),
                                const SizedBox(height: 20),
                                AuthTextfield(
                                  isObscure: true,
                                  hintText: "Password",
                                  controller: _passwordController,
                                ),
                                const SizedBox(height: 40),
                                AuthButton(
                                  isLoading: isLoading,
                                  buttonText: "Signup",
                                  onTap: () async {
                                    print("Boka");
                                    if (_formkey.currentState!.validate()) {
                                      ref
                                          .read(authViewModelProvider.notifier)
                                          .signupUser(
                                            name: _nameController.text,
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                          );
                                    } else {
                                      showToast(context,
                                          content: "Missing Fields!",
                                          type: ToastType.warning);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              LoginPage.route(),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.titleMedium,
                              text: "Aready have an account?  ",
                              children: const [
                                TextSpan(
                                  text: "Login",
                                  style: TextStyle(
                                    color: Palette.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
