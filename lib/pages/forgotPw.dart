import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_flutter/blocs/forgotPw/forgot_pw_bloc.dart';
import 'package:pp_flutter/blocs/forgotPw/forgot_pw_event.dart';
import 'package:pp_flutter/blocs/forgotPw/forgot_pw_state.dart';

class Forgotpw extends StatefulWidget {
  const Forgotpw({super.key});

  @override
  State<Forgotpw> createState() => _ForgotpwState();
}

class _ForgotpwState extends State<Forgotpw> {
  final TextEditingController _emailController = TextEditingController();
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _emailController.text.isNotEmpty;
    });
  }

  void _showCustomSnackBar(
    BuildContext context,
    String message, {
    bool isSuccess = true,
  }) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 12),
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: isSuccess ? Colors.black : Colors.red,
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFAAE2B),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Lupa Sandi',
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else {
            Navigator.of(context, rootNavigator: true).pop();
          }

          if (state is ForgotPasswordSuccess) {
            _emailController.clear(); // <-- Kosongkan input email
            _showCustomSnackBar(
              context,
              'Link reset password telah dikirim ke email kamu!',
              isSuccess: true,
            );
          } else if (state is ForgotPasswordFailure) {
            _showCustomSnackBar(context, state.message, isSuccess: false);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40),
                width: MediaQuery.of(context).size.width * 0.55,
                height: MediaQuery.of(context).size.height * 0.18,
                child: SvgPicture.asset('assets/forgot.svg', fit: BoxFit.cover),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Lupa Kata Sandi ?',
                        style: GoogleFonts.quicksand(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Masukkan email terdaftar, dan reset password ',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          fontSize: 13,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    _buildInputLabel('Email'),
                    _buildTextField(
                      controller: _emailController,
                      hintText: 'Masukkan email',
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            _isFormValid
                                ? () {
                                  context.read<ForgotPasswordBloc>().add(
                                    SendResetPasswordEmailEvent(
                                      _emailController.text,
                                    ),
                                  );
                                }
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _isFormValid
                                  ? const Color(0xffFAAE2B)
                                  : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'Kirimkan kode ke saya ',
                          style: GoogleFonts.quicksand(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.montserrat(
        fontSize: 13,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    bool isFilled = controller.text.isNotEmpty;
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor:
            isFilled ? const Color(0xffFFDDFAA) : const Color(0xffE0E0E0),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xff6A6A6A),
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
      ),
    );
  }
}
