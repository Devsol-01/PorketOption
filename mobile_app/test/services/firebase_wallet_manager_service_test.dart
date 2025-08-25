import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:firebase_core/firebase_core.dart';

import '../helpers/test_helpers.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('FirebaseWalletManagerServiceTest -', () {
    setUp(() {
      registerServices();
      getAndRegisterFirebaseAuthService();
      getAndRegisterFirebaseWalletManagerService();
    });
    tearDown(() => locator.reset());
  });
}
