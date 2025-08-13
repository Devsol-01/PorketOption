import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'email_viewmodel.dart';

class EmailView extends StackedView<EmailViewModel> {
  const EmailView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    EmailViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("EmailView")),
      ),
    );
  }

  @override
  EmailViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      EmailViewModel();
}
