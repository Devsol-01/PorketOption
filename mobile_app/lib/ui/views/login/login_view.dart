import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:stacked/stacked.dart';
import 'login_viewmodel.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              _buildHeader(),
              const SizedBox(height: 40),
              _buildLoginForm(viewModel),
              const SizedBox(height: 15),
              Container(
                  alignment: Alignment.bottomRight,
                  child: _buildRegisterLink(viewModel)),
              const SizedBox(height: 54),
              GestureDetector(
                  onTap: viewModel.login, child: _buildLoginButton(viewModel)),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white, // Light mode background
              borderRadius: BorderRadius.circular(17.65),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1D84F3).withOpacity(0.1),
                  offset: const Offset(-1.53, 1.53),
                  blurRadius: 7.67,
                  inset: true, // 👈 requires flutter_inset_box_shadow
                ),
                BoxShadow(
                  color: const Color(0xFF1D84F3).withOpacity(0.1),
                  offset: const Offset(1.53, 1.53),
                  blurRadius: 2.30,
                  inset: true,
                ),
              ],
            ),
            child: Image.asset('lib/assets/logo1.png')),
        const SizedBox(height: 24),
        const Text(
          "Welcome back,",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 24,
            height: 29 / 24, // lineHeight = 29px ÷ fontSize = 24px
            color: const Color(0xFF004CE8),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sign in to your account',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginForm(LoginViewModel viewModel) {
    return Column(
      children: [
        _buildTextField(
          controller: viewModel.emailController,
          label: 'Email Address',
          hint: 'Enter your email address',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: viewModel.passwordController,
          label: 'Password',
          hint: 'Enter your password',
          icon: Icons.lock_outline,
          isPassword: true,
          isPasswordVisible: viewModel.isPasswordVisible,
          onPasswordToggle: viewModel.togglePasswordVisibility,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onPasswordToggle,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 70, // more height for floating label
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label, // 👈 floating label
          labelStyle: const TextStyle(
            color: Colors.black, // adjust to match background
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(icon, size: 22, color: Colors.grey[700]),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 20,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(48),
            borderSide: const BorderSide(color: Color(0xFFDADADA), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(48),
            borderSide: const BorderSide(color: Color(0xFF9E9E9E), width: 1.5),
          ),
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF9E9E9E),
          ),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey[700],
                  ),
                  onPressed: onPasswordToggle,
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildLoginButton(LoginViewModel viewModel) {
    return SizedBox(
      height: 56,
      child: Container(
        width: 366,
        height: 39,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(46),
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(29, 132, 243, 0.1),
                offset: Offset(-4, 4),
                blurRadius: 20,
                spreadRadius: 0,
                inset: true),
            BoxShadow(
                color: Color.fromRGBO(29, 132, 243, 0.1),
                offset: Offset(4, 4),
                blurRadius: 6,
                spreadRadius: 0,
                inset: true),
          ],
        ),
        child: Center(
          child: viewModel.isBusy
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: const Color(0xFF004CE8),
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF004CE8),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink(LoginViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end, // 👈 moves it to the right
      children: [
        const Text(
          'Don’t have an account? ',
          style: TextStyle(color: Colors.black),
        ),
        GestureDetector(
          onTap: viewModel.navigateToRegister,
          child: const Text(
            'Sign Up',
            style: TextStyle(
              color: Color(0xFF004CE8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();
}
