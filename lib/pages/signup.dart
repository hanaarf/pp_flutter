import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pp_flutter/blocs/regist/regist_bloc.dart';
import 'package:pp_flutter/blocs/regist/regist_event.dart';
import 'package:pp_flutter/blocs/regist/regist_state.dart';
import 'package:pp_flutter/pages/jenjangPage.dart';
import 'package:pp_flutter/pages/signin.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isNameFilled = false;
  bool _isEmailFilled = false;
  bool _isPasswordFilled = false;
  bool _isConfirmPasswordFilled = false;
  bool _isConfirmPasswordMatch = false;

  bool _isPasswordVisible = false;
  bool _isPasswordVisiblee = false;

  bool _isPasswordValid = false;
  bool _isAlphabetChecked = false;
  bool _isNumberChecked = false;
  bool _isLengthChecked = false;

  String? _password = '';

  void _validatePassword(String password) {
    setState(() {
      _isAlphabetChecked = RegExp(r'[a-zA-Z]').hasMatch(password);
      _isNumberChecked = RegExp(r'[0-9]').hasMatch(password);
      _isLengthChecked = password.length >= 8;
      _isPasswordValid =
          _isAlphabetChecked && _isNumberChecked && _isLengthChecked;
    });
  }

  void _validateConfirmPassword(String confirmPassword) {
    setState(() {
      _isConfirmPasswordMatch = confirmPassword == _password;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<RegistBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => JenjangPage()),
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Gagal mendaftar: \${state.error}")),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.70,
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: SvgPicture.asset(
                        'assets/logoDaftar.svg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 25),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputField(
                            label: 'Nama Lengkap',
                            controller: _nameController,
                            isFilled: _isNameFilled,
                            onChanged:
                                (value) => setState(
                                  () => _isNameFilled = value.isNotEmpty,
                                ),
                            hintText: 'Masukkan Nama Lengkapmu',
                          ),
                          SizedBox(height: 20),
                          _buildInputField(
                            label: 'Email',
                            controller: _emailController,
                            isFilled: _isEmailFilled,
                            onChanged:
                                (value) => setState(
                                  () => _isEmailFilled = value.isNotEmpty,
                                ),
                            hintText: 'Masukkan email',
                          ),
                          SizedBox(height: 20),
                          _buildPasswordField(),
                          SizedBox(height: 20),
                          _buildConfirmPasswordField(),
                          SizedBox(height: 20),
                          _buildPasswordChecklist(),
                          SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  (_isNameFilled &&
                                          _isEmailFilled &&
                                          _isPasswordValid &&
                                          _isPasswordFilled &&
                                          _isConfirmPasswordFilled &&
                                          _isConfirmPasswordMatch)
                                      ? () {
                                        context.read<RegistBloc>().add(
                                          RegisterRequested(
                                            name: _nameController.text.trim(),
                                            email: _emailController.text.trim(),
                                            password: _passwordController.text,
                                            confirmPassword:
                                                _confirmPasswordController.text,
                                          ),
                                        );
                                      }
                                      : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    (_isNameFilled &&
                                            _isEmailFilled &&
                                            _isPasswordValid &&
                                            _isPasswordFilled &&
                                            _isConfirmPasswordFilled &&
                                            _isConfirmPasswordMatch)
                                        ? Color(0xffFAAE2B)
                                        : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: Text(
                                'Buat Akun',
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Memiliki akun? ',
                                style: GoogleFonts.montserrat(
                                  fontSize: 13,
                                  color: Color(0xff6A6A6A),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SigninPages(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Masuk',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 13,
                                    color: Color(0xff0000EE),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required bool isFilled,
    required Function(String) onChanged,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 13,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: isFilled ? Color(0xffFFDDFAA) : Color(0xffE0E0E0),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Color(0xff6A6A6A),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Buat Kata Sandi',
          style: GoogleFonts.montserrat(
            fontSize: 13,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 5),
        TextField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          onChanged: (value) {
            setState(() {
              _password = value;
              _isPasswordFilled = value.isNotEmpty;
              _validatePassword(value);
              _validateConfirmPassword(_confirmPasswordController.text);
            });
          },
          decoration: InputDecoration(
            filled: true,
            fillColor:
                _isPasswordFilled ? Color(0xffFFDDFAA) : Color(0xffE0E0E0),
            hintText: 'Buat Kata Sandi Baru',
            hintStyle: TextStyle(
              color: Color(0xff6A6A6A),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Color(0xff6A6A6A),
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Konfirmasi Kata Sandi',
          style: GoogleFonts.montserrat(
            fontSize: 13,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 5),
        TextField(
          controller: _confirmPasswordController,
          obscureText: !_isPasswordVisiblee,
          onChanged: (value) {
            setState(() {
              _isConfirmPasswordFilled = value.isNotEmpty;
              _validateConfirmPassword(value);
            });
          },
          decoration: InputDecoration(
            filled: true,
            fillColor:
                _isConfirmPasswordFilled
                    ? Color(0xffFFDDFAA)
                    : Color(0xffE0E0E0),
            hintText: 'Konfirmasi Kata Sandi',
            hintStyle: TextStyle(
              color: Color(0xff6A6A6A),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisiblee ? Icons.visibility : Icons.visibility_off,
                color: Color(0xff6A6A6A),
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisiblee = !_isPasswordVisiblee;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordChecklist() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kata sandi harus mencakup : ',
          style: TextStyle(
            color: Color(0xff6A6A6A),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        SizedBox(height: 5),
        _buildChecklistTile('Terdiri dari huruf alphabet', _isAlphabetChecked),
        _buildChecklistTile('Terdiri dari angka', _isNumberChecked),
        _buildChecklistTile('Terdiri dari 8 karakter', _isLengthChecked),
      ],
    );
  }

  Widget _buildChecklistTile(String text, bool checked) {
    return Row(
      children: [
        Checkbox(value: checked, onChanged: null),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: Color(0xff6A6A6A),
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
