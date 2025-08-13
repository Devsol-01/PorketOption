import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'lock_save_viewmodel.dart';

class LockSaveView extends StackedView<LockSaveViewModel> {
  const LockSaveView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LockSaveViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("LockSaveView")),
      ),
    );
  }

  @override
  LockSaveViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LockSaveViewModel();
}
