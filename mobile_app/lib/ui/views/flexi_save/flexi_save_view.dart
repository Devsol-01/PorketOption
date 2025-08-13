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
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("FlexiSaveView")),
      ),
    );
  }

  @override
  FlexiSaveViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      FlexiSaveViewModel();
}
