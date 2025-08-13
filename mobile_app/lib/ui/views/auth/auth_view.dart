import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'auth_viewmodel.dart';

class AuthView extends StackedView<AuthViewModel> {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AuthViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),

              // Header
              _buildHeader(),
              const SizedBox(height: 50),

              // Auth Toggle
              _buildAuthToggle(viewModel),
              const SizedBox(height: 30),

              // Auth Form
              viewModel.isLoginMode
                  ? _buildLoginForm(viewModel)
                  : _buildRegisterForm(viewModel),
              const SizedBox(height: 24),

              // Auth Button
              _buildAuthButton(viewModel),
              const SizedBox(height: 16),

              // Forgot Password (Login only)
              if (viewModel.isLoginMode) _buildForgotPassword(viewModel),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // App Logo/Icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFF6C5CE7),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C5CE7).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.account_balance_wallet,
            color: Colors.white,
            size: 50,
          ),
        ),
        const SizedBox(height: 24),

        // Title
        const Text(
          'Starknet Wallet',
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle
        const Text(
          'Your gateway to decentralized finance',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAuthToggle(AuthViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => viewModel.setLoginMode(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: viewModel.isLoginMode
                      ? const Color(0xFF6C5CE7)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Sign In',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: viewModel.isLoginMode ? Colors.white : Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => viewModel.setLoginMode(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: !viewModel.isLoginMode
                      ? const Color(0xFF6C5CE7)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Sign Up',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !viewModel.isLoginMode ? Colors.white : Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(AuthViewModel viewModel) {
    return Column(
      children: [
        // Email
        _buildTextField(
          controller: viewModel.emailController,
          label: 'Email Address',
          hint: 'Enter your email address',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),

        // Password
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

  Widget _buildRegisterForm(AuthViewModel viewModel) {
    return Column(
      children: [
        // First Name & Last Name Row
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: viewModel.firstNameController,
                label: 'First Name',
                hint: 'First name',
                icon: Icons.person_outline,
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: viewModel.lastNameController,
                label: 'Last Name',
                hint: 'Last name',
                icon: Icons.person_outline,
                textInputAction: TextInputAction.next,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Email
        _buildTextField(
          controller: viewModel.emailController,
          label: 'Email Address',
          hint: 'Enter your email address',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),

        // Password
        _buildTextField(
          controller: viewModel.passwordController,
          label: 'Password',
          hint: 'Create a strong password',
          icon: Icons.lock_outline,
          isPassword: true,
          isPasswordVisible: viewModel.isPasswordVisible,
          onPasswordToggle: viewModel.togglePasswordVisibility,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),

        // Confirm Password
        _buildTextField(
          controller: viewModel.confirmPasswordController,
          label: 'Confirm Password',
          hint: 'Confirm your password',
          icon: Icons.lock_outline,
          isPassword: true,
          isPasswordVisible: viewModel.isConfirmPasswordVisible,
          onPasswordToggle: viewModel.toggleConfirmPasswordVisibility,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),

        // Referral Code (Optional)
        _buildTextField(
          controller: viewModel.referralCodeController,
          label: 'Referral Code (Optional)',
          hint: 'Enter referral code if you have one',
          icon: Icons.card_giftcard_outlined,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword && !isPasswordVisible,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: Icon(icon, color: Colors.grey, size: 20),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: onPasswordToggle,
                  )
                : null,
            filled: true,
            fillColor: const Color(0xFF2A2A2A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6C5CE7), width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthButton(AuthViewModel viewModel) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: viewModel.isBusy
            ? null
            : (viewModel.isLoginMode ? viewModel.signIn : viewModel.register),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6C5CE7),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: viewModel.isBusy
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                viewModel.isLoginMode ? 'Sign In' : 'Create Account & Wallet',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildForgotPassword(AuthViewModel viewModel) {
    return GestureDetector(
      onTap: viewModel.showForgotPasswordDialog,
      child: const Text(
        'Forgot Password?',
        style: TextStyle(
          color: Color(0xFF6C5CE7),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  AuthViewModel viewModelBuilder(BuildContext context) => AuthViewModel();
}
