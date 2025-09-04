# TODO: Display Real USDC Balance on Dashboard

## Current Issues
- Dashboard shows fixed $3000 balance instead of real USDC balance
- Wallet address retrieval failing in getUsdcBalance
- Need to load real blockchain balance

## Tasks
- [x] Fix wallet address retrieval in wallet_service.dart getUsdcBalance method
- [x] Update dashboard_viewmodel.dart to load real USDC balance
- [x] Update dashboard_view.dart to display real USDC balance
- [x] Test balance loading functionality
- [x] Verify wallet initialization works correctly
- [x] Fix USDC approval for contract deposits
- [x] Add contract existence validation
- [x] Add detailed error logging for transaction failures

## Files to Edit
- mobile_app/lib/services/wallet_service.dart
- mobile_app/lib/ui/views/dashboard/dashboard_viewmodel.dart
- mobile_app/lib/ui/views/dashboard/dashboard_view.dart
- mobile_app/lib/services/contract_service.dart

## Current Status
✅ USDC balance display working ($70.0 shown)
✅ Wallet address retrieval fixed
✅ Dashboard loads real USDC balance
✅ USDC approval working with wallet service
✅ Contract existence check added
✅ Detailed error logging added

## Next Steps
- Test contract deployment on Starknet Sepolia
- Verify contract has flexi_deposit function
- Test complete deposit flow after contract is deployed
