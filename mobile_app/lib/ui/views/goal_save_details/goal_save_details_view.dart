import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'goal_save_details_viewmodel.dart';

class GoalSaveDetailsView extends StackedView<GoalSaveDetailsViewModel> {
  const GoalSaveDetailsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    GoalSaveDetailsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("GoalSaveDetailsView")),
      ),
    );
  }

  @override
  GoalSaveDetailsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      GoalSaveDetailsViewModel();
}
