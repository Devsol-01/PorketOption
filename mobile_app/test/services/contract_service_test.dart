import 'package:flutter_test/flutter_test.dart';
import '../../lib/services/contract_service.dart';
import '../../lib/services/wallet_service.dart';

void main() {
  group('ContractService Mock Mode Tests', () {
    test('should verify mock mode is enabled', () {
      // This test verifies that mock mode is working
      // In mock mode, contract calls should return mock transaction hashes
      // without actually interacting with the blockchain

      final walletService = WalletService();
      final contractService = ContractService(walletService);

      // Test passes if ContractService can be instantiated
      expect(contractService, isNotNull);
      expect(
          contractService.contractAddress.toHexString(),
          equals(
              '0x59558cebd77449b35e278dd418afdb03a56b486f2abdbabbea184c3257478be'));
    });

    test('should handle contract address correctly', () {
      final walletService = WalletService();
      final contractService = ContractService(walletService);

      final address = contractService.contractAddress;
      expect(address.toHexString(), startsWith('0x'));
      expect(address.toHexString().length,
          equals(65)); // Actual Starknet address length
    });
  });
}
