import 'package:flutter/material.dart';

abstract class BaseFormScreen extends StatefulWidget {
  const BaseFormScreen({Key? key}) : super(key: key);
}

abstract class BaseFormScreenState<T extends BaseFormScreen> extends State<T> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = [];

  void showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    _controllers.add(controller); // Lưu controller để dispose sau
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      obscureText: obscure,
      keyboardType: keyboard,
      validator: validator ??
          (val) => val == null || val.isEmpty ? 'Vui lòng nhập $label' : null,
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  GlobalKey<FormState> get formKey => _formKey;

  Widget buildForm(BuildContext context, List<Widget> children);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(getTitle())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: buildForm(context, buildFormFields()),
        ),
      ),
    );
  }

  String getTitle(); // Tiêu đề của màn hình
  List<Widget> buildFormFields(); // Các trường nhập liệu của màn hình
}