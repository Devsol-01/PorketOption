import 'package:flutter/material.dart';
import 'package:mobile_app/extensions/theme_context_extension.dart';
import 'package:stacked/stacked.dart';
import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';

import 'email_viewmodel.dart';

class EmailView extends StackedView<EmailViewModel> {
  const EmailView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    EmailViewModel viewModel,
    Widget? child,
  ) {
    final TextEditingController emailController = TextEditingController();
    return Scaffold(
      // Enhanced background with primary color hints
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0F1F), // Hint of primary color
              Color(0xFF1A1A1A), // Your original color
              Color(0xFF0F0F1F), // Hint of primary color
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17.0),
                  child: Column(
                    children: [
                      // Top section with back button and title - SAME STRUCTURE
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, bottom: 32.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: context.primaryTextColor,
                                size: 24,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            const Expanded(
                              child: Text(
                                'Sign In',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(
                                width: 48), // Balance the back button
                          ],
                        ),
                      ),

                      // Content with flexible spacing - SAME STRUCTURE
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo - Enhanced shadows only
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.8, end: 1.0),
                            duration: const Duration(milliseconds: 1),
                            curve: Curves.slowMiddle,
                            builder: (context, scaleValue, child) {
                              return AnimatedContainer(
                                duration: const Duration(seconds: 2),
                                width: 110,
                                height: 110,
                                transform: Matrix4.identity()
                                  ..scale(scaleValue),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF675DFF),
                                      Color(0xFF4F46E5),
                                      Color(0xFF3B37C9),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF675DFF)
                                          .withOpacity(0.25),
                                      blurRadius: 20,
                                      offset: const Offset(0, 6),
                                    ),
                                    BoxShadow(
                                      color: const Color(0xFF4F46E5)
                                          .withOpacity(0.15),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                    size: 48,
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 30),

                          // Welcome text - same but with subtle shadow
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                              color: context.primaryTextColor,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              shadows: const [
                                Shadow(
                                  color: Color(0xFF675DFF),
                                  offset: Offset(0, 0),
                                  blurRadius: 8,
                                ),
                                Shadow(
                                  color: Colors.black54,
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Sign in to your account',
                            style: TextStyle(
                              color: context.secondaryTextColor,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 48),

                          // Email input section - Enhanced background and shadows only
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email Address',
                                style: TextStyle(
                                  color: context.primaryTextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(
                                      0xFF1E1E24), // Darker background for contrast
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF4F46E5).withOpacity(
                                        0.15), // More subtle border
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF4F46E5)
                                          .withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: emailController,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Enter your email',
                                    hintStyle: TextStyle(
                                      color: Color(0xFF9CA3AF),
                                      fontSize: 16,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 20,
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Continue button - Enhanced shadows only
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFF675DFF),
                                  Color(0xFF4F46E5),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF675DFF).withOpacity(0.25),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle continue with email
                                print(
                                    viewModel.navigate);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: const Text(
                                'Continue with Email',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Bottom section - Privacy protection text - SAME
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Protected by ',
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 14,
                              ),
                            ),
                            Icon(
                              Icons.security,
                              color: context.primaryTextColor,
                              size: 16,
                            ),
                            Text(
                              ' privy',
                              style: TextStyle(
                                color: context.primaryTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  EmailViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      EmailViewModel();
}
