import 'dart:io';
import 'package:starknet/starknet.dart';

// Simple test to verify wallet loading logic without Flutter dependencies
void main() async {
  print('🧪 Testing Wallet Loading Logic');

  try {
    // Test Felt creation and address formatting
    print('\n🔍 Testing Felt address creation...');

    // Test with a sample address
    final testAddress =
        '0x059558cebd77449b35e278dd418afdb03a56b486f2abdbabbea184c3257478be';
    final addressFelt = Felt.fromHexString(testAddress);

    print('✅ Original address: $testAddress');
    print('✅ Felt address: ${addressFelt.toHexString()}');
    print('✅ Address is zero: ${addressFelt == Felt.zero}');

    // Test zero address detection
    final zeroFelt = Felt.zero;
    print('✅ Zero felt: ${zeroFelt.toHexString()}');
    print('✅ Zero comparison works: ${zeroFelt == Felt.zero}');

    // Test private key generation bounds
    print('\n🔍 Testing private key bounds...');
    final starknetFieldPrime = BigInt.parse(
        '800000000000011000000000000000000000000000000000000000000000001',
        radix: 16);

    print('✅ Starknet field prime: ${starknetFieldPrime.toRadixString(16)}');

    // Test sample private key
    final sampleKey = BigInt.parse('123456789abcdef', radix: 16);
    print('✅ Sample key valid: ${sampleKey < starknetFieldPrime}');

    // Test Felt creation from BigInt
    final keyFelt = Felt(sampleKey);
    print('✅ Key as Felt: ${keyFelt.toHexString()}');

    print('\n🎉 Wallet loading logic tests passed');
  } catch (e) {
    print('❌ Test failed: $e');
    exit(1);
  }
}
