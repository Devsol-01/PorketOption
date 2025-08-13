import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'group_save_viewmodel.dart';

class GroupSaveView extends StackedView<GroupSaveViewModel> {
  const GroupSaveView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    GroupSaveViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("GroupSaveView")),
      ),
    );
  }

  @override
  GroupSaveViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      GroupSaveViewModel();
}
