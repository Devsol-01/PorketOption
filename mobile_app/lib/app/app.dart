import 'package:mobile_app/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:mobile_app/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mobile_app/ui/views/bottom_nav/bottom_nav_view.dart';
import 'package:mobile_app/ui/views/dashboard/dashboard_view.dart';
import 'package:mobile_app/ui/views/email/email_view.dart';
import 'package:mobile_app/ui/views/flexi_save/flexi_save_view.dart';
import 'package:mobile_app/ui/views/goal_save/goal_save_view.dart';
import 'package:mobile_app/ui/views/group_save/group_save_view.dart';
import 'package:mobile_app/ui/views/investment/investment_view.dart';
import 'package:mobile_app/ui/views/lock_save/lock_save_view.dart';
import 'package:mobile_app/ui/views/onboarding/onboarding_view.dart';
import 'package:mobile_app/ui/views/profile/profile_view.dart';
import 'package:mobile_app/ui/views/saving/saving_view.dart';
import 'package:mobile_app/ui/views/verification/verification_view.dart';
import 'package:mobile_app/ui/bottom_sheets/crypto_deposit/crypto_deposit_sheet.dart';
import 'package:mobile_app/ui/bottom_sheets/deposit/deposit_sheet.dart';
import 'package:mobile_app/ui/bottom_sheets/withdraw/withdraw_sheet.dart';
import 'package:mobile_app/ui/bottom_sheets/group_save_selection/group_save_selection_sheet.dart';
import 'package:mobile_app/services/wallet_service.dart';
import 'package:mobile_app/services/auth_service.dart';
import 'package:mobile_app/services/token_service.dart';
import 'package:mobile_app/services/firebase_wallet_manager_service.dart';
import 'package:mobile_app/services/firebase_auth_service.dart';
import 'package:mobile_app/ui/views/auth/auth_view.dart';
import 'package:mobile_app/ui/views/register/register_view.dart';
import 'package:mobile_app/services/api_service.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView),
    MaterialRoute(page: BottomNavView),
    MaterialRoute(page: DashboardView),
    MaterialRoute(page: EmailView),
    MaterialRoute(page: FlexiSaveView),
    MaterialRoute(page: GoalSaveView),
    MaterialRoute(page: GroupSaveView),
    MaterialRoute(page: InvestmentView),
    MaterialRoute(page: LockSaveView),
    MaterialRoute(page: OnboardingView),
    MaterialRoute(page: ProfileView),
    MaterialRoute(page: SavingView),
    MaterialRoute(page: VerificationView),
    MaterialRoute(page: AuthView),
    MaterialRoute(page: RegisterView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: WalletService),
    LazySingleton(classType: AuthService),
    LazySingleton(classType: TokenService),
    LazySingleton(classType: FirebaseWalletManagerService),
    LazySingleton(classType: FirebaseAuthService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: ApiService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: CryptoDepositSheet),
    StackedBottomsheet(classType: DepositSheet),
    StackedBottomsheet(classType: WithdrawSheet),
    StackedBottomsheet(classType: GroupSaveSelectionSheet),
// @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
