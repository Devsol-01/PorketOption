//import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'flexi_save_viewmodel.dart';

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class FlexiSaveView extends StackedView<FlexiSaveViewModel> {
  const FlexiSaveView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    FlexiSaveViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
          child: Container(
        width: 171,
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white, // background: #FFFFFF
          borderRadius: BorderRadius.circular(46), // pill shape
          boxShadow: [
            BoxShadow(
                color: const Color.fromRGBO(29, 132, 243, 0.1),
                offset: const Offset(-4, 4),
                blurRadius: 20,
                inset: true),
            BoxShadow(
                color: const Color.fromRGBO(29, 132, 243, 0.1),
                offset: const Offset(4, 4),
                blurRadius: 6,
                inset: true),
          ],
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Colors.blue), // Example icon
              SizedBox(width: 10),
              Text(
                "Deposit",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  @override
  FlexiSaveViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      FlexiSaveViewModel();
}
