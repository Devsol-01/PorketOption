// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i24;
import 'package:flutter/material.dart';
import 'package:mobile_app/ui/views/auth/auth_view.dart' as _i15;
import 'package:mobile_app/ui/views/bottom_nav/bottom_nav_view.dart' as _i3;
import 'package:mobile_app/ui/views/create_private_group_save/create_private_group_save_view.dart'
    as _i21;
import 'package:mobile_app/ui/views/create_public_group_save/create_public_group_save_view.dart'
    as _i20;
import 'package:mobile_app/ui/views/dashboard/dashboard_view.dart' as _i4;
import 'package:mobile_app/ui/views/email/email_view.dart' as _i5;
import 'package:mobile_app/ui/views/flexi_save/flexi_save_view.dart' as _i6;
import 'package:mobile_app/ui/views/goal_save/create_goal/create_goal_view.dart'
    as _i18;
import 'package:mobile_app/ui/views/goal_save/goal_save_view.dart' as _i7;
import 'package:mobile_app/ui/views/goal_save_details/goal_save_details_view.dart'
    as _i23;
import 'package:mobile_app/ui/views/group_save/group_save_view.dart' as _i8;
import 'package:mobile_app/ui/views/group_save_details/group_save_details_view.dart'
    as _i22;
import 'package:mobile_app/ui/views/investment/investment_view.dart' as _i9;
import 'package:mobile_app/ui/views/lock_save/create_lock/create_lock_view.dart'
    as _i19;
import 'package:mobile_app/ui/views/lock_save/lock_save_view.dart' as _i10;
import 'package:mobile_app/ui/views/onboarding/onboarding_view.dart' as _i11;
import 'package:mobile_app/ui/views/porket_save/porket_save_view.dart' as _i17;
import 'package:mobile_app/ui/views/profile/profile_view.dart' as _i12;
import 'package:mobile_app/ui/views/register/register_view.dart' as _i16;
import 'package:mobile_app/ui/views/saving/saving_view.dart' as _i13;
import 'package:mobile_app/ui/views/startup/startup_view.dart' as _i2;
import 'package:mobile_app/ui/views/verification/verification_view.dart'
    as _i14;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i25;

class Routes {
  static const startupView = '/startup-view';

  static const bottomNavView = '/bottom-nav-view';

  static const dashboardView = '/dashboard-view';

  static const emailView = '/email-view';

  static const flexiSaveView = '/flexi-save-view';

  static const goalSaveView = '/goal-save-view';

  static const groupSaveView = '/group-save-view';

  static const investmentView = '/investment-view';

  static const lockSaveView = '/lock-save-view';

  static const onboardingView = '/onboarding-view';

  static const profileView = '/profile-view';

  static const savingView = '/saving-view';

  static const verificationView = '/verification-view';

  static const authView = '/auth-view';

  static const registerView = '/register-view';

  static const porketSaveView = '/porket-save-view';

  static const createGoalView = '/create-goal-view';

  static const createLockView = '/create-lock-view';

  static const createPublicGroupSaveView = '/create-public-group-save-view';

  static const createPrivateGroupSaveView = '/create-private-group-save-view';

  static const groupSaveDetailsView = '/group-save-details-view';

  static const goalSaveDetailsView = '/goal-save-details-view';

  static const all = <String>{
    startupView,
    bottomNavView,
    dashboardView,
    emailView,
    flexiSaveView,
    goalSaveView,
    groupSaveView,
    investmentView,
    lockSaveView,
    onboardingView,
    profileView,
    savingView,
    verificationView,
    authView,
    registerView,
    porketSaveView,
    createGoalView,
    createLockView,
    createPublicGroupSaveView,
    createPrivateGroupSaveView,
    groupSaveDetailsView,
    goalSaveDetailsView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.startupView,
      page: _i2.StartupView,
    ),
    _i1.RouteDef(
      Routes.bottomNavView,
      page: _i3.BottomNavView,
    ),
    _i1.RouteDef(
      Routes.dashboardView,
      page: _i4.DashboardView,
    ),
    _i1.RouteDef(
      Routes.emailView,
      page: _i5.EmailView,
    ),
    _i1.RouteDef(
      Routes.flexiSaveView,
      page: _i6.FlexiSaveView,
    ),
    _i1.RouteDef(
      Routes.goalSaveView,
      page: _i7.GoalSaveView,
    ),
    _i1.RouteDef(
      Routes.groupSaveView,
      page: _i8.GroupSaveView,
    ),
    _i1.RouteDef(
      Routes.investmentView,
      page: _i9.InvestmentView,
    ),
    _i1.RouteDef(
      Routes.lockSaveView,
      page: _i10.LockSaveView,
    ),
    _i1.RouteDef(
      Routes.onboardingView,
      page: _i11.OnboardingView,
    ),
    _i1.RouteDef(
      Routes.profileView,
      page: _i12.ProfileView,
    ),
    _i1.RouteDef(
      Routes.savingView,
      page: _i13.SavingView,
    ),
    _i1.RouteDef(
      Routes.verificationView,
      page: _i14.VerificationView,
    ),
    _i1.RouteDef(
      Routes.authView,
      page: _i15.AuthView,
    ),
    _i1.RouteDef(
      Routes.registerView,
      page: _i16.RegisterView,
    ),
    _i1.RouteDef(
      Routes.porketSaveView,
      page: _i17.PorketSaveView,
    ),
    _i1.RouteDef(
      Routes.createGoalView,
      page: _i18.CreateGoalView,
    ),
    _i1.RouteDef(
      Routes.createLockView,
      page: _i19.CreateLockView,
    ),
    _i1.RouteDef(
      Routes.createPublicGroupSaveView,
      page: _i20.CreatePublicGroupSaveView,
    ),
    _i1.RouteDef(
      Routes.createPrivateGroupSaveView,
      page: _i21.CreatePrivateGroupSaveView,
    ),
    _i1.RouteDef(
      Routes.groupSaveDetailsView,
      page: _i22.GroupSaveDetailsView,
    ),
    _i1.RouteDef(
      Routes.goalSaveDetailsView,
      page: _i23.GoalSaveDetailsView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.StartupView: (data) {
      return _i24.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.StartupView(),
        settings: data,
      );
    },
    _i3.BottomNavView: (data) {
      return _i24.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.BottomNavView(),
        settings: data,
      );
    },
    _i4.DashboardView: (data) {
      return _i24.MaterialPageRoute<dynamic>(
        builder: (context) => const _i4.DashboardView(),
        settings: data,
      );
    },
    _i5.EmailView: (data) {
      return _i24.MaterialPageRoute<dynamic>(
        builder: (context) => const _i5.EmailView(),
        settings: data,
      );
    },
    _i6.FlexiSaveView: (data) {
      return _i24.MaterialPageRoute<dynamic>(
        builder: (context) => const _i6.FlexiSaveView(),
        settings: data,
      );
    },
    _i7.GoalSaveView: (data) {
      return _i24.MaterialPageRoute<dynamic>(
        builder: (context) => const _i7.GoalSaveView(),
        settings: data,
      );
    },
    _i8.GroupSaveView: (data) {
      return _i24.MaterialPageRoute<dynamic>(
        builder: (context) => const _i8.GroupSaveView(),
        settings: data,
      );
    },
    _i9.InvestmentView: (data) {
      return _i24.MaterialPageRoute<dynamic>(
        builder: (context) => const _i9.InvestmentView(),
        settings: data,
      );
    },
    _i10.LockSaveView: (data) {
      return _i24.MaterialPageRoute<dynamic>(
        builder: (context) => const _i10.LockSaveView(),
        settings: data,
      );
    },
    _i11.OnboardingView: (data) {
      return _i24.MaterialPageRoute<dynamic>(
        builder: (context) => const _i11.OnboardingView(),
        settings: data,
      );
    },
    _i12.ProfileView: (data) {
      return _i24.MaterialPageRoute<dynamic>(
        builder: (context) => const _i12.ProfileView(),
        settings: data,
      );
    },
    _i13.SavingView: (data) {
      return _i24.MaterialPageRoute<dynamic>(
        builder: (context) => const _i13.SavingView(),
        settings: data,
      );
    },
    _i14.VerificationView: (data) {
      return _i24.MaterialPageRoute<dynamic>(
        builder: (context) => const _i14.VerificationView(),
        settings: data,
      );
    },
    _i15.AuthView: (data) {
      return _i24.MaterialPageRoute<dynamic>(
        builder: (context) => const _i15.AuthView(),
        settings: data,
      );
    },
    _i16.RegisterView: (data) {
      return _i24.MaterialPageRoute<dynamic>(
        builder: (context) => const _i16.RegisterView(),
        settings: data,
      );
    },
    _i17.PorketSaveView: (data) {
      return _i24.MaterialPageRoute<dynamic>(
        builder: (context) => const _i17.PorketSaveView(),
        settings: data,
      );
    },
    _i18.CreateGoalView: (data) {
      return _i24.MaterialPageRoute<dynamic>(
        builder: (context) => const _i18.CreateGoalView(),
        settings: data,
      );
    },
    _i19.CreateLockView: (data) {
      final args = data.getArgs<CreateLockViewArguments>(nullOk: false);
      return _i24.MaterialPageRoute<dynamic>(
        builder: (context) => _i19.CreateLockView(
            key: args.key, selectedPeriod: args.selectedPeriod),
        settings: data,
      );
    },
    _i20.CreatePublicGroupSaveView: (data) {
      return _i24.MaterialPageRoute<dynamic>(
        builder: (context) => const _i20.CreatePublicGroupSaveView(),
        settings: data,
      );
    },
    _i21.CreatePrivateGroupSaveView: (data) {
      return _i24.MaterialPageRoute<dynamic>(
        builder: (context) => const _i21.CreatePrivateGroupSaveView(),
        settings: data,
      );
    },
    _i22.GroupSaveDetailsView: (data) {
      return _i24.MaterialPageRoute<dynamic>(
        builder: (context) => const _i22.GroupSaveDetailsView(),
        settings: data,
      );
    },
    _i23.GoalSaveDetailsView: (data) {
      return _i24.MaterialPageRoute<dynamic>(
        builder: (context) => const _i23.GoalSaveDetailsView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class CreateLockViewArguments {
  const CreateLockViewArguments({
    this.key,
    required this.selectedPeriod,
  });

  final _i24.Key? key;

  final Map<String, dynamic> selectedPeriod;

  @override
  String toString() {
    return '{"key": "$key", "selectedPeriod": "$selectedPeriod"}';
  }

  @override
  bool operator ==(covariant CreateLockViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.selectedPeriod == selectedPeriod;
  }

  @override
  int get hashCode {
    return key.hashCode ^ selectedPeriod.hashCode;
  }
}

extension NavigatorStateExtension on _i25.NavigationService {
  Future<dynamic> navigateToStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToBottomNavView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.bottomNavView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToDashboardView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.dashboardView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToEmailView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.emailView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToFlexiSaveView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.flexiSaveView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToGoalSaveView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.goalSaveView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToGroupSaveView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.groupSaveView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToInvestmentView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.investmentView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLockSaveView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.lockSaveView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOnboardingView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.onboardingView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.profileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSavingView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.savingView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToVerificationView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.verificationView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAuthView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.authView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToRegisterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.registerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPorketSaveView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.porketSaveView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCreateGoalView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.createGoalView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCreateLockView({
    _i24.Key? key,
    required Map<String, dynamic> selectedPeriod,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.createLockView,
        arguments:
            CreateLockViewArguments(key: key, selectedPeriod: selectedPeriod),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCreatePublicGroupSaveView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.createPublicGroupSaveView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCreatePrivateGroupSaveView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.createPrivateGroupSaveView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToGroupSaveDetailsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.groupSaveDetailsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToGoalSaveDetailsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.goalSaveDetailsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithBottomNavView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.bottomNavView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithDashboardView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.dashboardView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithEmailView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.emailView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithFlexiSaveView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.flexiSaveView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithGoalSaveView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.goalSaveView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithGroupSaveView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.groupSaveView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithInvestmentView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.investmentView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLockSaveView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.lockSaveView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOnboardingView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.onboardingView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.profileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSavingView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.savingView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithVerificationView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.verificationView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAuthView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.authView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithRegisterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.registerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithPorketSaveView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.porketSaveView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCreateGoalView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.createGoalView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCreateLockView({
    _i24.Key? key,
    required Map<String, dynamic> selectedPeriod,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.createLockView,
        arguments:
            CreateLockViewArguments(key: key, selectedPeriod: selectedPeriod),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCreatePublicGroupSaveView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.createPublicGroupSaveView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCreatePrivateGroupSaveView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.createPrivateGroupSaveView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithGroupSaveDetailsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.groupSaveDetailsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithGoalSaveDetailsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.goalSaveDetailsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
