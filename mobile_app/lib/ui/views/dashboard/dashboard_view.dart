import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'dashboard_viewmodel.dart';

class DashboardView extends StackedView<DashboardViewModel> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    DashboardViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: viewModel.isBusy ? null : viewModel.refresh,
          ),
        ],
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : _buildDashboardContent(context, viewModel),
    );
  }

  Widget _buildDashboardContent(
      BuildContext context, DashboardViewModel viewModel) {
    if (!viewModel.hasWallet) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No wallet found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Please log in to view your wallet',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wallet Info Card
            _buildWalletCard(viewModel),
            const SizedBox(height: 16),

            // Balance Cards
            _buildBalanceCards(viewModel),
            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(viewModel),
            const SizedBox(height: 24),

            // Wallet Status
            _buildWalletStatus(viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard(DashboardViewModel viewModel) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_balance_wallet, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Wallet Address',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      viewModel.walletInfo?.address ?? 'N/A',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18),
                    onPressed: () {
                      // Copy to clipboard functionality
                      // You might need to import 'package:flutter/services.dart'
                      // Clipboard.setData(ClipboardData(text: viewModel.walletInfo?.address ?? ''));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCards(DashboardViewModel viewModel) {
    return Row(
      children: [
        // USDC Balance (Primary)
        Expanded(
          flex: 2,
          child: Card(
            color: Colors.green[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.monetization_on, color: Colors.green[600]),
                      const SizedBox(width: 8),
                      Text(
                        'USDC Balance',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${viewModel.usdcBalance.toStringAsFixed(2)} USDC',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // ETH Balance (Secondary)
        Expanded(
          child: Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.currency_bitcoin, color: Colors.blue[600]),
                  const SizedBox(height: 8),
                  Text(
                    'ETH',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[800],
                    ),
                  ),
                  Text(
                    viewModel.formattedBalance,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(DashboardViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed:
                    viewModel.isBusy ? null : viewModel.navigateToSendUsdc,
                icon: const Icon(Icons.send),
                label: const Text('Send USDC'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: viewModel.isBusy ? null : viewModel.loadUsdcBalance,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWalletStatus(DashboardViewModel viewModel) {
    final isDeployed = viewModel.walletInfo?.isDeployed ?? false;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isDeployed ? Icons.check_circle : Icons.pending,
                  color: isDeployed ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  'Account Status',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isDeployed ? 'Account is deployed' : 'Account not deployed',
              style: TextStyle(
                color: isDeployed ? Colors.green : Colors.orange,
              ),
            ),
            if (!isDeployed) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: viewModel.isBusy ? null : viewModel.deployAccount,
                  child: const Text('Deploy Account'),
                ),
              ),
            ],
            const SizedBox(height: 16),

            ElevatedButton(
                onPressed: () => viewModel.logout(), child: Text('Log out'))

            // // Danger Zone
            // ExpansionTile(
            //   title: const Text(
            //     'Danger Zone',
            //     style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            //   ),
            //   children: [
            //     ListTile(
            //       leading: const Icon(Icons.delete_forever, color: Colors.red),
            //       title: const Text('Delete Wallet'),
            //       subtitle: const Text('This action cannot be undone'),
            //       onTap: () => _showDeleteWalletDialog(context, viewModel),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  void _showDeleteWalletDialog(
      BuildContext context, DashboardViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Wallet'),
          content: const Text(
            'Are you sure you want to delete this wallet? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                viewModel.deleteWallet();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  DashboardViewModel viewModelBuilder(BuildContext context) {
    return DashboardViewModel();
  }

  @override
  void onViewModelReady(DashboardViewModel viewModel) {
    // Initialize the viewmodel when the view is ready
    viewModel.initialize();
  }

  @override
  bool get reactive => true; // Enable reactive rebuilds when viewModel changes
}
