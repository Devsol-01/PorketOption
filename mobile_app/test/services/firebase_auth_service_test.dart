import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/app.locator.dart';
import 'package:mobile_app/services/firebase_auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../helpers/test_helpers.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('FirebaseAuthServiceTest -', () {
    setUp(() {
      registerServices();
      getAndRegisterFirebaseAuthService();
      getAndRegisterFirebaseWalletManagerService();
    });
    tearDown(() => locator.reset());

    test('RegistrationData model validation', () {
      // Test RegistrationData model
      final registrationData = RegistrationData(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        password: 'Password123!',
        referralCode: 'REF123',
      );

      expect(registrationData.firstName, 'John');
      expect(registrationData.lastName, 'Doe');
      expect(registrationData.email, 'john.doe@example.com');
      expect(registrationData.hasReferralCode, true);

      final registrationDataNoReferral = RegistrationData(
        firstName: 'Jane',
        lastName: 'Smith',
        email: 'jane.smith@example.com',
        password: 'Password123!',
      );

      expect(registrationDataNoReferral.hasReferralCode, false);
    });

    test('AppUser model validation', () {
      // Test AppUser model
      final now = DateTime.now();
      final appUser = AppUser(
        id: 'test-user-id',
        email: 'test@example.com',
        firstName: 'Test',
        lastName: 'User',
        walletAddress: '0x1234567890abcdef',
        referralCode: 'REF123',
        createdAt: now,
        lastLoginAt: now,
      );

      expect(appUser.id, 'test-user-id');
      expect(appUser.email, 'test@example.com');
      expect(appUser.fullName, 'Test User');
      expect(appUser.displayName, 'Test User');
      expect(appUser.walletAddress, '0x1234567890abcdef');
      expect(appUser.referralCode, 'REF123');

      // Test fromFirestore factory with manual data (simplified test)
      // Note: The fromFirestore method requires a DocumentSnapshot, so we'll test
      // the toFirestore method instead for this test
      final firestoreData = appUser.toFirestore();
      expect(firestoreData['email'], 'test@example.com');
      expect(firestoreData['firstName'], 'Test');
      expect(firestoreData['lastName'], 'User');
    });

    test('AppUser toFirestore conversion', () {
      final now = DateTime.now();
      final appUser = AppUser(
        id: 'test-user-id',
        email: 'test@example.com',
        firstName: 'Test',
        lastName: 'User',
        walletAddress: '0x1234567890abcdef',
        referralCode: 'REF123',
        createdAt: now,
        lastLoginAt: now,
      );

      final firestoreData = appUser.toFirestore();
      expect(firestoreData['email'], 'test@example.com');
      expect(firestoreData['firstName'], 'Test');
      expect(firestoreData['lastName'], 'User');
      expect(firestoreData['walletAddress'], '0x1234567890abcdef');
      expect(firestoreData['referralCode'], 'REF123');
    });

    test('AppUser copyWith method', () {
      final now = DateTime.now();
      final originalUser = AppUser(
        id: 'original-id',
        email: 'original@example.com',
        firstName: 'Original',
        lastName: 'User',
        walletAddress: '0xoriginal',
        referralCode: 'REF_ORIGINAL',
        createdAt: now,
        lastLoginAt: now,
      );

      final updatedUser = originalUser.copyWith(
        email: 'updated@example.com',
        walletAddress: '0xupdated',
      );

      expect(updatedUser.id, 'original-id');
      expect(updatedUser.email, 'updated@example.com');
      expect(updatedUser.firstName, 'Original');
      expect(updatedUser.walletAddress, '0xupdated');
      expect(updatedUser.referralCode, 'REF_ORIGINAL');
    });

    test('FirebaseAuthException validation', () {
      // Test custom exception
      final exception = FirebaseAuthException(
        code: 'test-error',
        message: 'Test error message',
      );

      expect(exception.code, 'test-error');
      expect(exception.message, 'Test error message');
      expect(exception.toString(), contains('FirebaseAuthException'));
      expect(exception.toString(), contains('test-error'));
      expect(exception.toString(), contains('Test error message'));
    });

    test('FirebaseAuthService instantiation', () {
      // Test that the service can be instantiated via locator
      final service = locator<FirebaseAuthService>();
      expect(service, isNotNull);
      // Since we're using mocks, we can't test the actual properties
      // but we can verify the service is available
      expect(service, isA<FirebaseAuthService>());
    });
  });
}
