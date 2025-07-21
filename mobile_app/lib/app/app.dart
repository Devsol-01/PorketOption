import 'package:mobile_app/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:mobile_app/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mobile_app/ui/views/dashboard/dashboard_view.dart';
import 'package:mobile_app/ui/views/bottom_nav/bottom_nav_view.dart';
import 'package:mobile_app/ui/views/investment/investment_view.dart';
import 'package:mobile_app/ui/views/profile/profile_view.dart';
import 'package:mobile_app/ui/views/saving/saving_view.dart';
import 'package:mobile_app/ui/bottom_sheets/deposit_sheet/deposit_sheet_sheet.dart';
import 'package:mobile_app/ui/bottom_sheets/crypto_deposit_sheet/crypto_deposit_sheet_sheet.dart';
import 'package:mobile_app/ui/views/goal_save/goal_save_view.dart';
import 'package:mobile_app/ui/views/flexi_save/flexi_save_view.dart';
import 'package:mobile_app/ui/views/lock_save/lock_save_view.dart';
import 'package:mobile_app/ui/views/group_save/group_save_view.dart';
import 'package:mobile_app/ui/bottom_sheets/withdraw_sheet/withdraw_sheet_sheet.dart';
import 'package:mobile_app/ui/views/onboarding/onboarding_view.dart';
import 'package:mobile_app/ui/views/email/email_view.dart';
import 'package:mobile_app/ui/views/verification/verification_view.dart';
import 'package:mobile_app/services/privy_service.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView),
    MaterialRoute(page: DashboardView),
    MaterialRoute(page: BottomNavView),
    MaterialRoute(page: InvestmentView),
    MaterialRoute(page: ProfileView),
    MaterialRoute(page: SavingView),
    MaterialRoute(page: GoalSaveView),
    MaterialRoute(page: FlexiSaveView),
    MaterialRoute(page: LockSaveView),
    MaterialRoute(page: GroupSaveView),
    MaterialRoute(page: OnboardingView),
    MaterialRoute(page: EmailView),
    MaterialRoute(page: VerificationView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: PrivyService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: DepositSheetSheet),
    StackedBottomsheet(classType: CryptoDepositSheetSheet),
    StackedBottomsheet(classType: WithdrawSheetSheet),
// @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
