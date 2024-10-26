import 'package:flutter/material.dart';
import 'package:solar/core/theme/app_pallete.dart';

OutlineInputBorder _border(Color color) => OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: 2.5,
      ),
      borderRadius: BorderRadius.circular(10),
    );

class SearchTile extends StatefulWidget {
  const SearchTile({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscure = false,
    this.readOnly = false,
    this.onTap,
    this.color = Palette.borderColor,
  });
  final String hintText;
  final TextEditingController controller;
  final bool isObscure;
  final bool readOnly;
  final VoidCallback? onTap;
  final Color color;

  @override
  State<SearchTile> createState() => _SearchTileState();
}

class _SearchTileState extends State<SearchTile> {
  bool _obscureText = true;
  @override
  void initState() {
    // TODO: implement initState
    _obscureText = widget.isObscure;
    super.initState();
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      controller: widget.controller,
      obscureText: _obscureText,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Palette.textColor,
            fontSize: 18,
          ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        enabledBorder: _border(Palette.borderColor),
        focusedBorder: _border(Palette.primaryColor),
        errorBorder: _border(Palette.errorColor),
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Palette.secondaryTextColor,
              fontSize: 16,
            ),
        suffixIcon: widget.isObscure
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Palette.secondaryTextColor,
                ),
                onPressed: _toggleObscureText,
              )
            : null,
      ),
      validator: (val) {
        if (val!.trim().isEmpty) {
          return "${widget.hintText} is missing";
        }
        return null;
      },
    );
  }
}
