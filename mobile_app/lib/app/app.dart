import 'package:mobile_app/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:mobile_app/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:mobile_app/ui/views/home/home_view.dart';
import 'package:mobile_app/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mobile_app/ui/views/dashboard/dashboard_view.dart';
import 'package:mobile_app/ui/views/bottom_nav/bottom_nav_view.dart';
import 'package:mobile_app/ui/views/investment/investment_view.dart';
import 'package:mobile_app/ui/views/profile/profile_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: DashboardView),
    MaterialRoute(page: BottomNavView),
    MaterialRoute(page: InvestmentView),
    MaterialRoute(page: ProfileView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
