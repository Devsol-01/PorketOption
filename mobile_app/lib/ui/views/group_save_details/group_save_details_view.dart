import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'group_save_details_viewmodel.dart';

class GroupSaveDetailsView extends StackedView<GroupSaveDetailsViewModel> {
  const GroupSaveDetailsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    GroupSaveDetailsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("GroupSaveDetailsView")),
      ),
    );
  }

  @override
  GroupSaveDetailsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      GroupSaveDetailsViewModel();
}
