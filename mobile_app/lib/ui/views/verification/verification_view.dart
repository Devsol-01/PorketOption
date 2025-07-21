import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/extensions/theme_context_extension.dart';
import 'package:stacked/stacked.dart';

import 'verification_viewmodel.dart';

class VerificationView extends StackedView<VerificationViewModel> {
  final String email;
  
  const VerificationView({super.key, required this.email});

  @override
  Widget builder(
    BuildContext context,
    VerificationViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Verify Email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 48),
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF2D2D3A),
                ),
                child: const Center(
                  child: Icon(Icons.check, color: Colors.white, size: 32),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Verify Your Email',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'We sent a 6-digit code to $email. Enter it below.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 16),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return Container(
                    width: 48,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF3A3A3A)),
                    ),
                    child: TextField(
                      controller: viewModel.controllers[index],
                      focusNode: viewModel.focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) =>
                          viewModel.onDigitChanged(index, value),
                      onTap: () => viewModel.controllers[index].selection =
                          TextSelection.fromPosition(TextPosition(
                              offset:
                                  viewModel.controllers[index].text.length)),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap:
                    viewModel.remainingTime == 0 ? viewModel.resendCode : null,
                child: Text(
                  viewModel.remainingTime > 0
                      ? 'Resend code in ${viewModel.remainingTime}s'
                      : 'Resend code',
                  style: TextStyle(
                    color: viewModel.remainingTime > 0
                        ? const Color(0xFF6B7280)
                        : const Color(0xFF675DFF),
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed:
                      viewModel.isCodeComplete ? viewModel.verifyCode : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: viewModel.isCodeComplete
                        ? const Color(0xFF675DFF)
                        : const Color(0xFF3A3A3A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'Verify & Continue',
                    style: TextStyle(fontSize: 16,color: context.primaryTextColor,),
                    
                  ),
                ),
              ),
              const Spacer(),
              const SizedBox(height: 24),
              const Text(
                'Didn’t receive a code? Check your spam folder or try again.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  @override
  VerificationViewModel viewModelBuilder(BuildContext context) =>
      VerificationViewModel();

  @override
  void onViewModelReady(VerificationViewModel viewModel) {
    viewModel.init();
    viewModel.setEmail(email); // Pass the email to the viewmodel
  }
}
