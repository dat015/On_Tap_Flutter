import 'package:flutter/material.dart';
import 'package:on_tap_1/database/database_helper.dart';
import 'package:on_tap_1/models/user.dart';
import 'package:on_tap_1/screens/base_form.dart';
import 'package:on_tap_1/screens/login.dart';

class Register extends BaseFormScreen {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends BaseFormScreenState<Register>
    with SingleTickerProviderStateMixin {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  DateTime? _birthDate;
  String? _gender;
  final _genders = ['Nam', 'Nữ', 'Khác'];
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

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  void _submit() {
    if (!formKey.currentState!.validate()) return;
    if (_passCtrl.text != _confirmPassCtrl.text) {
      showSnack('Mật khẩu không khớp!');
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
    showSnack('Đăng ký thành công: ${user.name}, ${user.email}');
    formKey.currentState!.reset();
  }

  @override
  String getTitle() => 'Đăng ký tài khoản';

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
              Icons.person_add,
              size: 80,
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
          "Tạo tài khoản mới",
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
    SizedBox(height: 20),
    FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: _nameCtrl,
          decoration: InputDecoration(
            labelText: 'Họ và tên',
            prefixIcon: Icon(
              Icons.person,
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
        child: InkWell(
          onTap: _selectDate,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Ngày sinh',
              prefixIcon: Icon(
                Icons.calendar_today,
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
            child: Text(
              _birthDate == null
                  ? 'Chọn ngày sinh'
                  : '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}',
            ),
          ),
        ),
      ),
    ),
    SizedBox(height: 16),
    FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: DropdownButtonFormField<String>(
          value: _gender,
          decoration: InputDecoration(
            labelText: 'Giới tính',
            prefixIcon: Icon(
              Icons.people,
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
          items:
              _genders
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
          onChanged: (val) => setState(() => _gender = val),
          validator: (val) => val == null ? 'Vui lòng chọn giới tính' : null,
        ),
      ),
    ),
    SizedBox(height: 16),
    FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
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
          validator: (val) {
            if (val == null || val.isEmpty) return 'Vui lòng nhập Email';
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val))
              return 'Email không hợp lệ';
            return null;
          },
        ),
      ),
    ),
    SizedBox(height: 16),
    FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Số điện thoại',
            prefixIcon: Icon(
              Icons.phone,
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
          validator: (val) {
            if (val == null || val.isEmpty)
              return 'Vui lòng nhập số điện thoại';
            if (!RegExp(r'^\d{10,11}$').hasMatch(val))
              return 'Số điện thoại không hợp lệ';
            return null;
          },
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
          validator: (val) {
            if (val == null || val.isEmpty) return 'Vui lòng nhập mật khẩu';
            if (val.length < 6) return 'Mật khẩu phải có ít nhất 6 ký tự';
            return null;
          },
        ),
      ),
    ),
    SizedBox(height: 16),
    FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: _confirmPassCtrl,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Xác nhận mật khẩu',
            prefixIcon: Icon(
              Icons.lock_outline,
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
          validator:
              (val) => val != _passCtrl.text ? 'Mật khẩu không khớp' : null,
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
            'Đăng ký',
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
            MaterialPageRoute(builder: (context) => Login()),
          );
        },
        child: Text(
          'Đã có tài khoản? Đăng nhập',
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
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 20),
        children: children,
      ),
    );
  }
}
