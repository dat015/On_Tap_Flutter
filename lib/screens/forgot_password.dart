import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:on_tap_1/database/database_helper.dart';
import 'package:on_tap_1/models/user.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  String _generateRandomPassword(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  Future<void> _sendEmail(String toEmail, String newPassword) async {
    String username = 'testabc151004@gmail.com'; // thay bằng email của bạn
    String password = 'vjbnixcuyykncfna';    // dùng App Password nếu dùng Gmail

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Hệ thống Flutter')
      ..recipients.add(toEmail)
      ..subject = 'Khôi phục mật khẩu'
      ..text = 'Mật khẩu mới của bạn là: $newPassword';

    try {
      final sendReport = await send(message, smtpServer);
      print('Gửi mail thành công: ${sendReport.toString()}');
    } catch (e) {
      print('Lỗi gửi mail: $e');
      _showSnack('Không thể gửi email. Vui lòng thử lại sau.');
    }
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailCtrl.text.trim();
    final user = await DatabaseHelper.instance.getUserByEmail(email);

    if (user == null) {
      _showSnack('Không tìm thấy người dùng với email này');
      return;
    }

    final newPassword = _generateRandomPassword(8);
    user.password = newPassword;
    await DatabaseHelper.instance.updateUser(user);

    await _sendEmail(email, newPassword);
    _showSnack('Đã gửi mật khẩu mới tới email của bạn.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quên mật khẩu')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailCtrl,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Vui lòng nhập email';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) return 'Email không hợp lệ';
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetPassword,
                child: Text('Gửi mật khẩu mới'),
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
    super.dispose();
  }
}
