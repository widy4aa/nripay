import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nirpay/core/router/app_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF4F7FB), Colors.white, Color(0xFFC7F4ED)],
          stops: [0.0, 0.4, 1.0],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 40.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                _buildHeader(),
                const SizedBox(height: 40),
                _buildForm(context),
                const SizedBox(height: 40),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E24),
              height: 1.3,
            ),
            children: [
              TextSpan(text: 'Selamat Datang di\n'),
              TextSpan(text: 'Nir'),
              TextSpan(
                text: 'Pay',
                style: TextStyle(color: Color(0xFF238AED)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Selamat Datang di NirPay. Silahkan Login Jika\nAnda Sudah Memiliki Akun',
          style: TextStyle(fontSize: 14, color: Color(0xFF4A4A54), height: 1.5),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildTextField(
          hint: 'Email atau Nomor Ponsel',
          icon: Icons.email_outlined,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          hint: 'Kata Sandi',
          icon: Icons.lock_outline_rounded,
          isPassword: true,
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Lupa kata sandi?',
            style: TextStyle(
              color: Color(0xFF7D8C9E),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context.goNamed(AppRouteNames.wallet),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF009CFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              shadowColor: const Color(0xFF009CFF).withValues(alpha: 0.3),
            ),
            child: const Text(
              'Masuk',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildDivider(),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(color: Color(0xFFE2E6EE)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Replace with actual Google icon asset if available
                Icon(Icons.g_mobiledata_rounded, color: Colors.red, size: 28),
                SizedBox(width: 8),
                Text(
                  'Masuk dengan Google',
                  style: TextStyle(
                    color: Color(0xFF4A4A54),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E6EE)),
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF7D8C9E), fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFF7D8C9E), size: 20),
          suffixIcon: isPassword
              ? const Icon(
                  Icons.visibility_outlined,
                  color: Color(0xFF7D8C9E),
                  size: 20,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey.withValues(alpha: 0.3),
            thickness: 1,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'ATAU',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Color(0xFF7D8C9E),
              letterSpacing: 1.5,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey.withValues(alpha: 0.3),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Belum punya akun? ',
          style: TextStyle(color: Color(0xFF4A4A54), fontSize: 14),
        ),
        GestureDetector(
          onTap: () => context.pushNamed(AppRouteNames.registerStep1),
          child: const Text(
            'Daftar Sekarang',
            style: TextStyle(
              color: Color(0xFF009CFF),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
