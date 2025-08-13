import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'goal_save_viewmodel.dart';

class GoalSaveView extends StackedView<GoalSaveViewModel> {
  const GoalSaveView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    GoalSaveViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("GoalSaveView")),
      ),
    );
  }

  @override
  GoalSaveViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      GoalSaveViewModel();
}
