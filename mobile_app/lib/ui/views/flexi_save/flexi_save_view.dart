import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'flexi_save_viewmodel.dart';

class FlexiSaveView extends StackedView<FlexiSaveViewModel> {
  const FlexiSaveView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    FlexiSaveViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Container(
          width: 200, // Fixed width from Figma (W 40)
          height: 200, // Fixed height from Figma (H 40)
          padding: const EdgeInsets.all(14), // Padding: 14px
          decoration: BoxDecoration(
            color: Colors.white, // Primary color/White 100
            borderRadius: BorderRadius.circular(11.72), // Corner radius
            boxShadow: [
              // Inner shadow (Figma effect) – Flutter doesn't have native inner shadow
              // This is an approximation using normal shadow
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 1),
                blurRadius: 2,
                spreadRadius: -2,
              ),
            ],
          ),
          alignment: Alignment.center, // Align content center
          child: Text(
            'text',
            style: const TextStyle(
              color: Color(0xFF0000FF), // Accent color/Blue 100
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
    
  }

  @override
  FlexiSaveViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      FlexiSaveViewModel();
}
