import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:on_tap_1/database/database_helper.dart';
import 'package:on_tap_1/models/user.dart';
import 'package:on_tap_1/screens/base_form.dart';

class ForgotPasswordScreen extends BaseFormScreen {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends BaseFormScreenState<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();

  String _generateRandomPassword(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(
      length,
      (index) => chars[rand.nextInt(chars.length)],
    ).join();
  }

  Future<void> _sendEmail(String toEmail, String newPassword) async {
    String username = 'testabc151004@gmail.com';
    String password = 'vjbnixcuyykncfna';

    final smtpServer = gmail(username, password);

    final message =
        Message()
          ..from = Address(username, 'Hệ thống Flutter')
          ..recipients.add(toEmail)
          ..subject = 'Khôi phục mật khẩu'
          ..text = 'Mật khẩu mới của bạn là: $newPassword';

    try {
      final sendReport = await send(message, smtpServer);
      print('Gửi mail thành công: ${sendReport.toString()}');
    } catch (e) {
      print('Lỗi gửi mail: $e');
      showSnack('Không thể gửi email. Vui lòng thử lại sau.');
    }
  }

  Future<void> _resetPassword() async {
    if (!formKey.currentState!.validate()) return;

    final email = _emailCtrl.text.trim();
    final user = await DatabaseHelper.instance.getUserByEmail(email);

    if (user == null) {
      showSnack('Không tìm thấy người dùng với email này');
      return;
    }

    final newPassword = _generateRandomPassword(8);
    user.password = newPassword;
    await DatabaseHelper.instance.updateUser(user);

    await _sendEmail(email, newPassword);
    showSnack('Đã gửi mật khẩu mới tới email của bạn.');
  }

  @override
  String getTitle() => 'Quên mật khẩu';

  @override
  List<Widget> buildFormFields() => [
    Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Icon(
        Icons.lock_reset,
        size: 80,
        color: Theme.of(context).primaryColor,
      ),
    ),
    Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "Khôi phục mật khẩu",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
        textAlign: TextAlign.center,
      ),
    ),
    SizedBox(height: 10),
    Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "Nhập email của bạn để nhận mật khẩu mới",
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        textAlign: TextAlign.center,
      ),
    ),
    SizedBox(height: 30),
    Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: _emailCtrl,
        decoration: InputDecoration(
          labelText: 'Email',
          prefixIcon: Icon(Icons.email),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Vui lòng nhập email';
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value))
            return 'Email không hợp lệ';
          return null;
        },
      ),
    ),
    SizedBox(height: 20),
    Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _resetPassword,
        child: Text('Gửi mật khẩu mới', style: TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
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
          colors: [Colors.white, Colors.blue[50]!],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}
