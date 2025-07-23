use anchor_lang::prelude::*;
use anchor_spl::token::{self, Mint, Token, TokenAccount, Transfer};

declare_id!("2AmsYgcLobdupv7Z9idFFaoNATc98Eqn1f7kE4F6RvyK");

// USDC Mint address for Devnet (change for Mainnet)
const USDC_MINT: &str = "Es9vMFrzaCERh8b1w7QwA4RKHwM1z6y1c5bK4e8k6V2";

// Interest rates (example: 5% for Flexi, 8-15% for Lock Save based on duration)
const FLEXI_INTEREST_BPS: u64 = 500; // 5% annual, in basis points
const LOCK_SAVE_TIERS: [(u64, u64, u64); 5] = [
    (10, 30, 800),   // 8% for 10-30 days
    (31, 60, 900),   // 9% for 31-60 days
    (91, 180, 1100), // 11% for 91-180 days
    (181, 270, 1300),// 13% for 181-270 days
    (271, 365, 1500) // 15% for 271-365 days
];

// Program entrypoint
#[program]
pub mod contract {
    use super::*;

    // Initialize (optional, can be used for global state)
    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        msg!("PorketOption contract initialized");
        Ok(())
    }

    // Deposit into Flexi Save
    pub fn deposit_flexi(ctx: Context<DepositFlexi>, amount: u64) -> Result<()> {
        // Transfer USDC from user to vault
        token::transfer(CpiContext::new(
            ctx.accounts.token_program.to_account_info(),
            Transfer {
                from: ctx.accounts.user_usdc.to_account_info(),
                to: ctx.accounts.flexi_vault.to_account_info(),
                authority: ctx.accounts.user.to_account_info(),
            },
        ), amount)?;
        // Update user FlexiSave balance
        let flexi = &mut ctx.accounts.flexi_save;
        flexi.balance += amount;
        Ok(())
    }

    // Withdraw from Flexi Save
    pub fn withdraw_flexi(ctx: Context<WithdrawFlexi>, amount: u64) -> Result<()> {
        let flexi = &mut ctx.accounts.flexi_save;
        require!(flexi.balance >= amount, CustomError::InsufficientBalance);
        // Transfer USDC from vault to user
        token::transfer(CpiContext::new(
            ctx.accounts.token_program.to_account_info(),
            Transfer {
                from: ctx.accounts.flexi_vault.to_account_info(),
                to: ctx.accounts.user_usdc.to_account_info(),
                authority: ctx.accounts.vault_authority.to_account_info(),
            },
        ), amount)?;
        flexi.balance -= amount;
        Ok(())
    }

    // Create a Lock Save
    pub fn create_lock_save(ctx: Context<CreateLockSave>, amount: u64, duration_days: u64, title: String) -> Result<()> {
        // Find interest rate based on duration
        let mut interest_bps = 0;
        for (min, max, bps) in LOCK_SAVE_TIERS.iter() {
            if &duration_days >= min && &duration_days <= max {
                interest_bps = *bps;
                break;
            }
        }
        require!(interest_bps > 0, CustomError::InvalidLockDuration);
        // Transfer USDC from user to vault
        token::transfer(CpiContext::new(
            ctx.accounts.token_program.to_account_info(),
            Transfer {
                from: ctx.accounts.user_usdc.to_account_info(),
                to: ctx.accounts.lock_vault.to_account_info(),
                authority: ctx.accounts.user.to_account_info(),
            },
        ), amount)?;
        // Create LockSave account
        let lock = &mut ctx.accounts.lock_save;
        lock.owner = ctx.accounts.user.key();
        lock.amount = amount;
        lock.start_ts = Clock::get()?.unix_timestamp as u64;
        lock.duration_days = duration_days;
        lock.interest_bps = interest_bps;
        lock.title = title;
        lock.claimed = false;
        Ok(())
    }

    // Withdraw matured Lock Save
    pub fn withdraw_lock_save(ctx: Context<WithdrawLockSave>) -> Result<()> {
        let lock = &mut ctx.accounts.lock_save;
        require!(!lock.claimed, CustomError::AlreadyClaimed);
        let now = Clock::get()?.unix_timestamp as u64;
        let maturity_ts = lock.start_ts + lock.duration_days * 86400;
        require!(now >= maturity_ts, CustomError::LockNotMatured);
        // Calculate interest
        let interest = lock.amount * lock.interest_bps * lock.duration_days / 36500 / 100;
        let total = lock.amount + interest;
        // Transfer USDC from vault to user
        token::transfer(CpiContext::new(
            ctx.accounts.token_program.to_account_info(),
            Transfer {
                from: ctx.accounts.lock_vault.to_account_info(),
                to: ctx.accounts.user_usdc.to_account_info(),
                authority: ctx.accounts.vault_authority.to_account_info(),
            },
        ), total)?;
        lock.claimed = true;
        Ok(())
    }
}

// Account for Flexi Save
#[account]
pub struct FlexiSave {
    pub owner: Pubkey,
    pub balance: u64,
    pub created_at: u64,
}

// Account for Lock Save
#[account]
pub struct LockSave {
    pub owner: Pubkey,
    pub amount: u64,
    pub start_ts: u64,
    pub duration_days: u64,
    pub interest_bps: u64,
    pub title: String,
    pub claimed: bool,
}

// Contexts
#[derive(Accounts)]
pub struct Initialize {}

#[derive(Accounts)]
pub struct DepositFlexi<'info> {
    #[account(mut)]
    pub user: Signer<'info>,
    #[account(mut)]
    pub user_usdc: Account<'info, TokenAccount>,
    #[account(mut)]
    pub flexi_vault: Account<'info, TokenAccount>,
    #[account(mut)]
    pub flexi_save: Account<'info, FlexiSave>,
    pub token_program: Program<'info, Token>,
}

#[derive(Accounts)]
pub struct WithdrawFlexi<'info> {
    #[account(mut)]
    pub user: Signer<'info>,
    #[account(mut)]
    pub user_usdc: Account<'info, TokenAccount>,
    #[account(mut)]
    pub flexi_vault: Account<'info, TokenAccount>,
    #[account(mut)]
    pub flexi_save: Account<'info, FlexiSave>,
    /// CHECK: PDA authority for vault
    pub vault_authority: AccountInfo<'info>,
    pub token_program: Program<'info, Token>,
}

#[derive(Accounts)]
pub struct CreateLockSave<'info> {
    #[account(mut)]
    pub user: Signer<'info>,
    #[account(mut)]
    pub user_usdc: Account<'info, TokenAccount>,
    #[account(mut)]
    pub lock_vault: Account<'info, TokenAccount>,
    #[account(init, payer = user, space = 8 + 128)]
    pub lock_save: Account<'info, LockSave>,
    pub system_program: Program<'info, System>,
    pub token_program: Program<'info, Token>,
}

#[derive(Accounts)]
pub struct WithdrawLockSave<'info> {
    #[account(mut)]
    pub user: Signer<'info>,
    #[account(mut)]
    pub user_usdc: Account<'info, TokenAccount>,
    #[account(mut)]
    pub lock_vault: Account<'info, TokenAccount>,
    #[account(mut)]
    pub lock_save: Account<'info, LockSave>,
    /// CHECK: PDA authority for vault
    pub vault_authority: AccountInfo<'info>,
    pub token_program: Program<'info, Token>,
}

// Custom errors
#[error_code]
pub enum CustomError {
    #[msg("Insufficient balance")]
    InsufficientBalance,
    #[msg("Invalid lock duration")]
    InvalidLockDuration,
    #[msg("Lock not matured")]
    LockNotMatured,
    #[msg("Already claimed")]
    AlreadyClaimed,
}
