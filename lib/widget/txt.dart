import 'package:flutter/material.dart';

class Textf extends StatefulWidget {
  final bool ob; // Whether the text should be obscured (for passwords, etc.)
  final String name; // Hint text for the TextField
  final TextEditingController controller; // Controller to manage the text field's state
  final String? Function(String?)? validator; // Validator function for error handling

  const Textf({
    Key? key,
    required this.name,
    this.ob = false,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  _TextfState createState() => _TextfState();
}

class _TextfState extends State<Textf> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.ob; // Initialize based on the `ob` parameter
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller, // Access controller using widget.controller
      obscureText: _obscureText, // Obscure text based on internal state
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromRGBO(64, 76, 90, 0.1), // Background color
        hintText: widget.name,
        hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: widget.ob
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: _obscureText ? Colors.grey : Colors.blue,
          ),
          onPressed: _toggleObscureText,
        )
            : null,
      ),
      validator: widget.validator, // Pass the validator function to TextFormField
    );
  }
}
