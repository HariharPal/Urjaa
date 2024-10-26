import 'package:flutter/material.dart';
import 'package:solar/core/theme/app_pallete.dart';
import 'package:solar/core/widget/utils.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.isLoading = false,
  });
  final String buttonText;
  final VoidCallback onTap;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        color: isLoading ? Colors.grey : Palette.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(395, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Palette.transparentColor,
          shadowColor: Palette.transparentColor,
        ),
        child: isLoading
            ? Loader()
            : Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
