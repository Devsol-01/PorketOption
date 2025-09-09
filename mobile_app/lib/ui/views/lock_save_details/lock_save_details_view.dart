import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'lock_save_details_viewmodel.dart';

class LockSaveDetailsView extends StackedView<LockSaveDetailsViewModel> {
  const LockSaveDetailsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LockSaveDetailsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("LockSaveDetailsView")),
      ),
    );
  }

  @override
  LockSaveDetailsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LockSaveDetailsViewModel();
}
