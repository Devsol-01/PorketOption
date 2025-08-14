import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mobile_app/services/wallet_service.dart';
import 'package:mobile_app/services/auth_service.dart';
import 'package:mobile_app/services/token_service.dart';
import 'package:mobile_app/services/firebase_wallet_manager_service.dart';
import 'package:mobile_app/services/firebase_auth_service.dart';
import 'package:mobile_app/services/api_service.dart';
// @stacked-import

import 'test_helpers.mocks.dart';

@GenerateMocks(
  [],
  customMocks: [
    MockSpec<NavigationService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<BottomSheetService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<DialogService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<WalletService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<AuthService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<TokenService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<FirebaseWalletManagerService>(
        onMissingStub: OnMissingStub.returnDefault),
    MockSpec<FirebaseAuthService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<ApiService>(onMissingStub: OnMissingStub.returnDefault),
// @stacked-mock-spec
  ],
)
void registerServices() {
  getAndRegisterNavigationService();
  getAndRegisterBottomSheetService();
  getAndRegisterDialogService();
  getAndRegisterWalletService();
  getAndRegisterAuthService();
  getAndRegisterTokenService();
  getAndRegisterFirebaseWalletManagerService();
  getAndRegisterFirebaseAuthService();
  getAndRegisterApiService();
// @stacked-mock-register
}

MockNavigationService getAndRegisterNavigationService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

MockBottomSheetService getAndRegisterBottomSheetService<T>({
  SheetResponse<T>? showCustomSheetResponse,
}) {
  _removeRegistrationIfExists<BottomSheetService>();
  final service = MockBottomSheetService();

  when(
    service.showCustomSheet<T, T>(
      enableDrag: anyNamed('enableDrag'),
      enterBottomSheetDuration: anyNamed('enterBottomSheetDuration'),
      exitBottomSheetDuration: anyNamed('exitBottomSheetDuration'),
      ignoreSafeArea: anyNamed('ignoreSafeArea'),
      isScrollControlled: anyNamed('isScrollControlled'),
      barrierDismissible: anyNamed('barrierDismissible'),
      additionalButtonTitle: anyNamed('additionalButtonTitle'),
      variant: anyNamed('variant'),
      title: anyNamed('title'),
      hasImage: anyNamed('hasImage'),
      imageUrl: anyNamed('imageUrl'),
      showIconInMainButton: anyNamed('showIconInMainButton'),
      mainButtonTitle: anyNamed('mainButtonTitle'),
      showIconInSecondaryButton: anyNamed('showIconInSecondaryButton'),
      secondaryButtonTitle: anyNamed('secondaryButtonTitle'),
      showIconInAdditionalButton: anyNamed('showIconInAdditionalButton'),
      takesInput: anyNamed('takesInput'),
      barrierColor: anyNamed('barrierColor'),
      barrierLabel: anyNamed('barrierLabel'),
      customData: anyNamed('customData'),
      data: anyNamed('data'),
      description: anyNamed('description'),
    ),
  ).thenAnswer(
    (realInvocation) =>
        Future.value(showCustomSheetResponse ?? SheetResponse<T>()),
  );

  locator.registerSingleton<BottomSheetService>(service);
  return service;
}

MockDialogService getAndRegisterDialogService() {
  _removeRegistrationIfExists<DialogService>();
  final service = MockDialogService();
  locator.registerSingleton<DialogService>(service);
  return service;
}

MockWalletService getAndRegisterWalletService() {
  _removeRegistrationIfExists<WalletService>();
  final service = MockWalletService();
  locator.registerSingleton<WalletService>(service);
  return service;
}

MockAuthService getAndRegisterAuthService() {
  _removeRegistrationIfExists<AuthService>();
  final service = MockAuthService();
  locator.registerSingleton<AuthService>(service);
  return service;
}

MockTokenService getAndRegisterTokenService() {
  _removeRegistrationIfExists<TokenService>();
  final service = MockTokenService();
  locator.registerSingleton<TokenService>(service);
  return service;
}

MockFirebaseWalletManagerService getAndRegisterFirebaseWalletManagerService() {
  _removeRegistrationIfExists<FirebaseWalletManagerService>();
  final service = MockFirebaseWalletManagerService();
  locator.registerSingleton<FirebaseWalletManagerService>(service);
  return service;
}

MockFirebaseAuthService getAndRegisterFirebaseAuthService() {
  _removeRegistrationIfExists<FirebaseAuthService>();
  final service = MockFirebaseAuthService();
  locator.registerSingleton<FirebaseAuthService>(service);
  return service;
}

MockApiService getAndRegisterApiService() {
  _removeRegistrationIfExists<ApiService>();
  final service = MockApiService();
  locator.registerSingleton<ApiService>(service);
  return service;
}
// @stacked-mock-create

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
