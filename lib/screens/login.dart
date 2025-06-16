import 'package:flutter/material.dart';
import 'package:on_tap_1/database/database_helper.dart';
import 'package:on_tap_1/screens/base_form.dart';
import 'package:on_tap_1/screens/forgot_password.dart';
import 'package:on_tap_1/screens/register.dart';

class Login extends BaseFormScreen {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends BaseFormScreenState<Login>
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!formKey.currentState!.validate()) {
      showSnack('Vui lòng điền đầy đủ thông tin');
      return;
    }

    final email = _emailCtrl.text;
    final password = _passCtrl.text;

    try {
      final user = await DatabaseHelper.instance.getUserByEmail(email);
      if (user != null && user.password == password) {
        showSnack('Đăng nhập thành công');
        // TODO: Navigate to home screen
      } else {
        showSnack('Email hoặc mật khẩu không đúng');
      }
    } catch (e) {
      showSnack('Lỗi đăng nhập: $e');
    }
  }

  @override
  String getTitle() => 'Đăng Nhập';

  @override
  List<Widget> buildFormFields() => [
    FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
            ),
            Icon(
              Icons.account_circle,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    ),
    FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Chào mừng trở lại!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
    SizedBox(height: 30),
    FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: _emailCtrl,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(
              Icons.email,
              color: Theme.of(context).primaryColor,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    ),
    SizedBox(height: 16),
    FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: _passCtrl,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Mật khẩu',
            prefixIcon: Icon(Icons.lock, color: Theme.of(context).primaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    ),
    SizedBox(height: 20),
    FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _submit,
          child: Text(
            'Đăng Nhập',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 2,
          ),
        ),
      ),
    ),
    FadeTransition(
      opacity: _fadeAnimation,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
          );
        },
        child: Text(
          'Quên mật khẩu?',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ),
    FadeTransition(
      opacity: _fadeAnimation,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Register()),
          );
        },
        child: Text(
          'Chưa có tài khoản? Đăng ký',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ),
  ];

  @override
  Widget buildForm(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Theme.of(context).primaryColor.withOpacity(0.1),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}
