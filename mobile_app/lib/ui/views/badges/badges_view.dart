import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'badges_viewmodel.dart';

class BadgesView extends StackedView<BadgesViewModel> {
  const BadgesView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    BadgesViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Badges',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Image(
                        image: AssetImage('lib/assets/badge5.png'),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                      child: GestureDetector(
                          onTap: () {},
                          child: Image.asset('lib/assets/badge1.png'))),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                          onTap: () {},
                          child: Image.asset('lib/assets/badge2.png'))),
                  const SizedBox(width: 16),
                  Expanded(
                      child: GestureDetector(
                          onTap: () {},
                          child: Image.asset('lib/assets/badge4.png'))),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                          onTap: () {},
                          child: Image.asset('lib/assets/badge.png'))),
                  const SizedBox(width: 16),
                  Expanded(
                      child: GestureDetector(
                          onTap: () {},
                          child: Image.asset('lib/assets/badge6.png'))),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                          onTap: () {},
                          child: Image.asset('lib/assets/badge7.png'))),
                  const SizedBox(width: 16),
                  Expanded(
                      child: GestureDetector(
                          onTap: () {},
                          child: Image.asset('lib/assets/badge8.png'))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  BadgesViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      BadgesViewModel();
}
