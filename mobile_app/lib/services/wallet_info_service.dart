import 'package:mobile_app/app/app.locator.dart';
import 'package:mobile_app/services/privy_service.dart';
import 'package:mobile_app/extensions/num_extensions.dart';

/// Service to handle wallet information and user data
class WalletInfoService {
  final _privyService = locator<PrivyService>();

  /// Get current authenticated user
  get currentUser => _privyService.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => _privyService.isAuthenticated;

  /// Check if user has any wallets
  bool get hasWallet {
    if (!isAuthenticated || currentUser == null) return false;
    try {
      // Try to access embedded wallets - this will help us understand the structure
      final wallets = currentUser.embeddedSolanaWallets;
      return wallets != null && wallets.isNotEmpty;
    } catch (e) {
      print('Error checking wallet: $e');
      return false;
    }
  }

  /// Get primary Solana wallet address
  String? get primaryWalletAddress {
    if (!hasWallet) return null;
    try {
      final wallets = currentUser.embeddedSolanaWallets;
      if (wallets != null && wallets.isNotEmpty) {
        final firstWallet = wallets.first;
        return firstWallet.address?.toString();
      }
    } catch (e) {
      print('Error getting wallet address: $e');
    }
    return null;
  }

  /// Get formatted wallet address (shortened for display)
  String get formattedWalletAddress {
    final address = primaryWalletAddress;
    if (address == null || address.isEmpty) {
      return 'No wallet';
    }
    if (address.length > 12) {
      return '${address.substring(0, 6)}...${address.substring(address.length - 6)}';
    }
    return address;
  }

  /// Get user's email address
  String? get userEmail {
    if (!isAuthenticated || currentUser == null) return null;
    try {
      // Try to get email from linked accounts
      final linkedAccounts = currentUser.linkedAccounts;
      if (linkedAccounts != null) {
        for (var account in linkedAccounts) {
          if (account.type == 'email') {
            return account.address;
          }
        }
      }
    } catch (e) {
      print('Error getting user email: $e');
    }
    return null;
  }

  /// Get user's display name
  String get displayName {
    final email = userEmail;
    if (email != null && email.isNotEmpty) {
      // Extract name part from email (before @)
      final atIndex = email.indexOf('@');
      if (atIndex > 0) {
        return email.substring(0, atIndex);
      }
      return email;
    }
    return 'User';
  }

  /// Get USDC wallet balance (placeholder - requires blockchain RPC call)
  /// This would need to be implemented with a Solana RPC client to fetch USDC token balance
  Future<double> getWalletBalance() async {
    final address = primaryWalletAddress;
    if (address == null) return 0.0;

    // TODO: Implement actual USDC balance fetching using Solana RPC
    // This should fetch the USDC token balance from the wallet address
    print('Getting USDC balance for wallet: $address');

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return mock USDC balance for demonstration
    return 100.75; // Mock USDC balance - replace with actual RPC call
  }

  /// Get formatted USDC balance string
  Future<String> getFormattedBalance() async {
    final balance = await getWalletBalance();
    return '${balance.toCurrency(symbol: ' 24')} USDC';
  }

  /// Copy wallet address to clipboard
  Future<void> copyWalletAddress() async {
    final address = primaryWalletAddress;
    if (address != null) {
      // TODO: Implement clipboard functionality
      print('Copying wallet address: $address');
    }
  }

  /// Get wallet info summary
  Map<String, dynamic> getWalletSummary() {
    return {
      'isAuthenticated': isAuthenticated,
      'hasWallet': hasWallet,
      'walletAddress': primaryWalletAddress,
      'formattedAddress': formattedWalletAddress,
      'userEmail': userEmail,
      'displayName': displayName,
    };
  }
}
