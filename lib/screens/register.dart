import 'package:flutter/material.dart';
import 'package:on_tap_1/database/database_helper.dart';
import 'package:on_tap_1/models/user.dart';
import 'package:on_tap_1/screens/login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  DateTime? _birthDate;
  String? _gender;
  final _genders = ['Nam', 'Nữ', 'Khác'];

  void _showSnack(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_passCtrl.text != _confirmPassCtrl.text) {
      _showSnack('Mật khẩu không khớp!');
      return;
    }

    final user = User(
      name: _nameCtrl.text,
      email: _emailCtrl.text,
      password: _passCtrl.text,
      phone: _phoneCtrl.text,
      dateOfBirth: _birthDate,
      gender: _gender,
    );

    DatabaseHelper.instance.insertUser(user);
    _showSnack('Đăng ký thành công: ${user.name}, ${user.email}');
    _formKey.currentState!.reset();
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool obscure = false,
    String? Function(String?)? validator,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      obscureText: obscure,
      keyboardType: keyboard,
      validator:
          validator ??
          (val) => (val == null || val.isEmpty) ? 'Vui lòng nhập $label' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network("https://th.bing.com/th/id/OIP.4H1DAYzCZ7UiE9PkBUkb_QHaEo?w=271&h=180&c=7&r=0&o=7&dpr=1.5&pid=1.7&rm=3")
      
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Center(
            child:   ListView(
            children: [
              _buildTextField(_nameCtrl, 'Họ và tên'),
              ListTile(
                title: Text(
                  _birthDate == null
                      ? 'Chọn ngày sinh'
                      : 'Ngày sinh: ${_birthDate!.toLocal()}'.split(' ')[0],
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: _selectDate,
              ),
              DropdownButtonFormField<String>(
                value: _gender,
                hint: Text('Chọn giới tính'),
                items:
                    _genders
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                onChanged: (val) => setState(() => _gender = val),
                validator:
                    (val) =>
                        (val == null || val.isEmpty)
                            ? 'Vui lòng chọn giới tính'
                            : null,
              ),
              _buildTextField(
                _emailCtrl,
                'Email',
                keyboard: TextInputType.emailAddress,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Vui lòng nhập Email';
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(val))
                    return 'Email không hợp lệ';
                  return null;
                },
              ),
              _buildTextField(
                _phoneCtrl,
                'Số điện thoại',
                keyboard: TextInputType.phone,
                validator: (val) {
                  if (val == null || val.isEmpty)
                    return 'Vui lòng nhập số điện thoại';
                  if (!RegExp(r'^\d{10,11}$').hasMatch(val))
                    return 'Số điện thoại không hợp lệ';
                  return null;
                },
              ),
              _buildTextField(
                _passCtrl,
                'Mật khẩu',
                obscure: true,
                validator: (val) {
                  if (val == null || val.isEmpty)
                    return 'Vui lòng nhập mật khẩu';
                  if (val.length < 6) return 'Mật khẩu phải có ít nhất 6 ký tự';
                  return null;
                },
              ),
              _buildTextField(
                _confirmPassCtrl,
                'Xác nhận mật khẩu',
                obscure: true,
                validator:
                    (val) =>
                        (val != _passCtrl.text) ? 'Mật khẩu không khớp' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: Text('Đăng ký')),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                child: Text('Đã có tài khoản? Đăng nhập'),
              ),
            ],
          ),
          ),
        
        ),
      ),
    );
  }

  @override
  void dispose() {
    [
      _nameCtrl,
      _emailCtrl,
      _passCtrl,
      _confirmPassCtrl,
      _phoneCtrl,
    ].forEach((c) => c.dispose());
    super.dispose();
  }
}
