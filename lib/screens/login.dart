import 'package:flutter/material.dart';
import 'package:on_tap_1/database/database_helper.dart';
import 'package:on_tap_1/screens/forgot_password.dart';
import 'register.dart'; // import trang đăng ký

class Login extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<Login> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      _showSnack('Vui lòng điền đầy đủ thông tin');
      return;
    }

    final email = _emailCtrl.text;
    final password = _passCtrl.text;

    try {
      final user = await DatabaseHelper.instance.getUserByEmail(email);
      if (user != null && user.password == password) {
        _showSnack('Đăng nhập thành công');
        // TODO: Navigate to home screen
      } else {
        _showSnack('Email hoặc mật khẩu không đúng');
      }
    } catch (e) {
      _showSnack('Lỗi đăng nhập: $e');
    }
  }

  Widget _buildField(
    TextEditingController ctrl,
    String label, {
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      obscureText: obscure,
      validator: validator ??
          (val) => (val == null || val.isEmpty) ? 'Vui lòng nhập $label' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng Nhập')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildField(_emailCtrl, 'Email'),
              SizedBox(height: 16),
              _buildField(_passCtrl, 'Mật khẩu', obscure: true),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: Text('Đăng Nhập')),

              SizedBox(height: 16),

              // 👉 Quên mật khẩu
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPasswordScreen()), // Cần tạo ForgotPassword widget
                  );
                },
                child: Text('Quên mật khẩu?'),
              ),

              // 👉 Chuyển sang đăng ký
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                  );
                },
                child: Text('Chưa có tài khoản? Đăng ký'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }
}
