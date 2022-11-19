import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  const InputField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.obscureText,
    this.focusNode,
    required this.autoCorrect,
    required this.enableSuggestions,
    this.textCapitalization,
    this.onFieldSubmitted,
    this.textInputAction,
    this.validator,
    this.onSaved,
    this.initialValue,
  }) : super(key: key);
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final FocusNode? focusNode;
  final bool autoCorrect;
  final bool enableSuggestions;
  final TextCapitalization? textCapitalization;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final String? initialValue;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool obscureText;

  @override
  void initState() {
    super.initState();
    obscureText = (widget.hintText == 'Password' ||
            widget.hintText == 'New Password' ||
            widget.hintText == 'Old Password' ||
            widget.hintText == 'Confirm Password')
        ? true
        : false;
  }

  OutlineInputBorder _outlinedInputBorder(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        gapPadding: 4.0,
        borderSide: BorderSide(
          color: color,
          width: 2.0,
        ),
      );

  Widget _textFormField(
          {required String hintText,
          required String labelText,
          required IconData icon}) =>
      TextFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          focusedBorder:
              _outlinedInputBorder(Theme.of(context).colorScheme.primary),
          // TODO UNPRESSED
          enabledBorder: _outlinedInputBorder(Colors.grey),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final inputWidth = MediaQuery.of(context).size.width * 0.85;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: TextFormField(
        initialValue: widget.initialValue,
// cursorHeight: 50.0,
        key: widget.key,
        controller: widget.controller,
        keyboardType: TextInputType.emailAddress,
        focusNode: widget.focusNode,
        autocorrect: widget.autoCorrect,
        enableSuggestions: widget.enableSuggestions,
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.none,
        obscureText: obscureText,
        onFieldSubmitted: widget.onFieldSubmitted,
        textInputAction: widget.textInputAction,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          focusedBorder:
              _outlinedInputBorder(Theme.of(context).colorScheme.primary),
          // TODO UNPRESSED
          enabledBorder: _outlinedInputBorder(Colors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
          constraints: BoxConstraints(
            maxWidth: inputWidth,
            minWidth: inputWidth,
          ),
          // fillColor: Colors.white54,
          // filled: false,
          hintText: widget.hintText,
          prefixIcon: Icon(
            widget.icon,
            color: Theme.of(context).colorScheme.primary,
            size: 30.0,
          ),
          suffixIcon: (widget.hintText == 'Password' ||
                  widget.hintText == 'Old Password' ||
                  widget.hintText == 'New Password' ||
                  widget.hintText == 'Confirm Password')
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  child: obscureText
                      ? const Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                          size: 30.0,
                        )
                      : Icon(
                          Icons.visibility,
                          color: Theme.of(context).colorScheme.primary,
                          size: 30.0,
                        ))
              : null,
        ),
        validator: widget.validator,
        onSaved: widget.onSaved,
      ),
    );
  }
}
