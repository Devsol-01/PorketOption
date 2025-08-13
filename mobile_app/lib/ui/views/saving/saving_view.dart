import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'saving_viewmodel.dart';

class SavingView extends StackedView<SavingViewModel> {
  const SavingView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SavingViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("SavingView")),
      ),
    );
  }

  @override
  SavingViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SavingViewModel();
}
