use anchor_lang::prelude::*;
use anchor_spl::token::{self, Mint, Token, TokenAccount, Transfer};

declare_id!("4TJynqBJZExUGUy9rSH5wFgAcSjhdwYjTAUJyt6qvoTh");

// USDC Mint address for Devnet (change for Mainnet)
const USDC_MINT: &str = "Es9vMFrzaCERh8b1w7QwA4RKHwM1z6y1c5bK4e8k6V2";

// Interest rates (example: 5% for Flexi, 8-15% for Lock Save based on duration)
const FLEXI_INTEREST_BPS: u64 = 500; // 5% annual, in basis points
const LOCK_SAVE_TIERS: [(u64, u64, u64); 5] = [
    (10, 30, 800),    // 8% for 10-30 days
    (31, 60, 900),    // 9% for 31-60 days
    (91, 180, 1100),  // 11% for 91-180 days
    (181, 270, 1300), // 13% for 181-270 days
    (271, 365, 1500), // 15% for 271-365 days
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
        emit!(DepositEvent {
            user: ctx.accounts.user.key(),
            amount,
            plan: "flexi".to_string(),
        });
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

    // Create a Goal Save
    pub fn create_goal_save(ctx: Context<CreateGoalSave>, purpose: String, category: String, target_amount: u64, frequency: String, start_ts: u64, end_ts: u64) -> Result<()> {
        let goal = &mut ctx.accounts.goal_save;
        goal.owner = ctx.accounts.user.key();
        goal.purpose = purpose.clone();
        goal.category = category;
        goal.target_amount = target_amount;
        goal.contributed = 0;
        goal.frequency = frequency;
        goal.start_ts = start_ts;
        goal.end_ts = end_ts;
        goal.status = 0;
        emit!(CreateGoalEvent {
            user: ctx.accounts.user.key(),
            goal: purpose,
            target: target_amount,
        });
        Ok(())
    }

    // Contribute to Goal Save
    pub fn contribute_goal_save(ctx: Context<ContributeGoalSave>, amount: u64) -> Result<()> {
        token::transfer(CpiContext::new(
            ctx.accounts.token_program.to_account_info(),
            Transfer {
                from: ctx.accounts.user_usdc.to_account_info(),
                to: ctx.accounts.goal_vault.to_account_info(),
                authority: ctx.accounts.user.to_account_info(),
            },
        ), amount)?;
        let goal = &mut ctx.accounts.goal_save;
        goal.contributed += amount;
        emit!(DepositEvent {
            user: ctx.accounts.user.key(),
            amount,
            plan: "goal".to_string(),
        });
        // Mark as completed if target reached
        if goal.contributed >= goal.target_amount {
            goal.status = 1;
        }
        Ok(())
    }

    // Create a Group Save
    pub fn create_group_save(ctx: Context<CreateGroupSave>, group_code: String, is_public: bool, description: String, category: String, target_amount: u64, frequency: String, start_ts: u64, end_ts: u64) -> Result<()> {
        let group = &mut ctx.accounts.group_save;
        group.group_code = group_code.clone();
        group.is_public = is_public;
        group.description = description;
        group.creator = ctx.accounts.user.key();
        group.category = category;
        group.target_amount = target_amount;
        group.contributed = 0;
        group.frequency = frequency;
        group.start_ts = start_ts;
        group.end_ts = end_ts;
        group.members = vec![ctx.accounts.user.key()];
        group.status = 0;
        emit!(CreateGroupEvent {
            user: ctx.accounts.user.key(),
            group_code,
            target: target_amount,
        });
        Ok(())
    }

    // Join a Group Save
    pub fn join_group_save(ctx: Context<JoinGroupSave>) -> Result<()> {
        let group = &mut ctx.accounts.group_save;
        let user = ctx.accounts.user.key();
        if !group.members.contains(&user) {
            group.members.push(user);
        }
        Ok(())
    }

    // Contribute to Group Save
    pub fn contribute_group_save(ctx: Context<ContributeGroupSave>, amount: u64) -> Result<()> {
        token::transfer(CpiContext::new(
            ctx.accounts.token_program.to_account_info(),
            Transfer {
                from: ctx.accounts.user_usdc.to_account_info(),
                to: ctx.accounts.group_vault.to_account_info(),
                authority: ctx.accounts.user.to_account_info(),
            },
        ), amount)?;
        let group = &mut ctx.accounts.group_save;
        group.contributed += amount;
        emit!(DepositEvent {
            user: ctx.accounts.user.key(),
            amount,
            plan: "group".to_string(),
        });
        // Mark as completed if target reached
        if group.contributed >= group.target_amount {
            group.status = 1;
        }
        Ok(())
    }

    // Automatically payout Goal Save if completed
    pub fn claim_goal_if_completed(ctx: Context<WithdrawGoalSave>) -> Result<()> {
        let goal = &mut ctx.accounts.goal_save;
        if goal.status != 1 {
            return Ok(()); // Not completed, do nothing
        }
        if goal.contributed == 0 {
            return Ok(()); // Nothing to payout
        }
        // Transfer all contributed USDC to user
        token::transfer(CpiContext::new(
            ctx.accounts.token_program.to_account_info(),
            Transfer {
                from: ctx.accounts.goal_vault.to_account_info(),
                to: ctx.accounts.user_usdc.to_account_info(),
                authority: ctx.accounts.vault_authority.to_account_info(),
            },
        ), goal.contributed)?;
        emit!(WithdrawEvent {
            user: ctx.accounts.user.key(),
            amount: goal.contributed,
            plan: "goal".to_string(),
        });
        goal.contributed = 0;
        Ok(())
    }

    // Automatically payout Group Save if completed
    pub fn claim_group_if_completed(ctx: Context<WithdrawGroupSave>) -> Result<()> {
        let group = &mut ctx.accounts.group_save;
        if group.status != 1 {
            return Ok(()); // Not completed, do nothing
        }
        if group.contributed == 0 {
            return Ok(()); // Nothing to payout
        }
        // Transfer all contributed USDC to the caller (could be split among members in a real app)
        token::transfer(CpiContext::new(
            ctx.accounts.token_program.to_account_info(),
            Transfer {
                from: ctx.accounts.group_vault.to_account_info(),
                to: ctx.accounts.user_usdc.to_account_info(),
                authority: ctx.accounts.vault_authority.to_account_info(),
            },
        ), group.contributed)?;
        emit!(WithdrawEvent {
            user: ctx.accounts.user.key(),
            amount: group.contributed,
            plan: "group".to_string(),
        });
        group.contributed = 0;
        Ok(())
    }

    // Withdraw from Flexi Save
    pub fn withdraw_flexi(ctx: Context<WithdrawFlexi>, amount: u64) -> Result<()> {
        let flexi = &mut ctx.accounts.flexi_save;
        require!(flexi.balance >= amount, CustomError::InsufficientBalance);
        // Transfer USDC from vault to user
        token::transfer(
            CpiContext::new(
                ctx.accounts.token_program.to_account_info(),
                Transfer {
                    from: ctx.accounts.flexi_vault.to_account_info(),
                    to: ctx.accounts.user_usdc.to_account_info(),
                    authority: ctx.accounts.vault_authority.to_account_info(),
                },
            ),
            amount,
        )?;
        flexi.balance -= amount;
        Ok(())
    }

    // Create a Lock Save
    pub fn create_lock_save(
        ctx: Context<CreateLockSave>,
        amount: u64,
        duration_days: u64,
        title: String,
    ) -> Result<()> {
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
        token::transfer(
            CpiContext::new(
                ctx.accounts.token_program.to_account_info(),
                Transfer {
                    from: ctx.accounts.user_usdc.to_account_info(),
                    to: ctx.accounts.lock_vault.to_account_info(),
                    authority: ctx.accounts.user.to_account_info(),
                },
            ),
            amount,
        )?;
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

    // Automatically payout matured Lock Save to user
    pub fn claim_lock_if_matured(ctx: Context<WithdrawLockSave>) -> Result<()> {
        let lock = &mut ctx.accounts.lock_save;
        if lock.claimed {
            return Ok(()); // Already claimed, do nothing
        }
        let now = Clock::get()?.unix_timestamp as u64;
        let maturity_ts = lock.start_ts + lock.duration_days * 86400;
        if now < maturity_ts {
            return Ok(()); // Not matured, do nothing
        }
        // Calculate interest
        let interest = lock.amount * lock.interest_bps * lock.duration_days / 36500 / 100;
        let total = lock.amount + interest;
        // Transfer USDC from vault to user
        token::transfer(
            CpiContext::new(
                ctx.accounts.token_program.to_account_info(),
                Transfer {
                    from: ctx.accounts.lock_vault.to_account_info(),
                    to: ctx.accounts.user_usdc.to_account_info(),
                    authority: ctx.accounts.vault_authority.to_account_info(),
                },
            ),
            total,
        )?;
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

// Goal Save
#[derive(Accounts)]
pub struct CreateGoalSave<'info> {
    #[account(mut)]
    pub user: Signer<'info>,
    #[account(init, payer = user, space = 8 + 256)]
    pub goal_save: Account<'info, GoalSave>,
    pub system_program: Program<'info, System>,
}

#[derive(Accounts)]
pub struct ContributeGoalSave<'info> {
    #[account(mut)]
    pub user: Signer<'info>,
    #[account(mut)]
    pub user_usdc: Account<'info, TokenAccount>,
    #[account(mut)]
    pub goal_vault: Account<'info, TokenAccount>,
    #[account(mut)]
    pub goal_save: Account<'info, GoalSave>,
    pub token_program: Program<'info, Token>,
}

#[derive(Accounts)]
pub struct WithdrawGoalSave<'info> {
    #[account(mut)]
    pub user: Signer<'info>,
    #[account(mut)]
    pub user_usdc: Account<'info, TokenAccount>,
    #[account(mut)]
    pub goal_vault: Account<'info, TokenAccount>,
    #[account(mut)]
    pub goal_save: Account<'info, GoalSave>,
    /// CHECK: PDA authority for vault
    pub vault_authority: AccountInfo<'info>,
    pub token_program: Program<'info, Token>,
}

// Group Save
#[derive(Accounts)]
pub struct CreateGroupSave<'info> {
    #[account(mut)]
    pub user: Signer<'info>,
    #[account(init, payer = user, space = 8 + 512)]
    pub group_save: Account<'info, GroupSave>,
    pub system_program: Program<'info, System>,
}

#[derive(Accounts)]
pub struct JoinGroupSave<'info> {
    #[account(mut)]
    pub user: Signer<'info>,
    #[account(mut)]
    pub group_save: Account<'info, GroupSave>,
}

#[derive(Accounts)]
pub struct ContributeGroupSave<'info> {
    #[account(mut)]
    pub user: Signer<'info>,
    #[account(mut)]
    pub user_usdc: Account<'info, TokenAccount>,
    #[account(mut)]
    pub group_vault: Account<'info, TokenAccount>,
    #[account(mut)]
    pub group_save: Account<'info, GroupSave>,
    pub token_program: Program<'info, Token>,
}

#[derive(Accounts)]
pub struct WithdrawGroupSave<'info> {
    #[account(mut)]
    pub user: Signer<'info>,
    #[account(mut)]
    pub user_usdc: Account<'info, TokenAccount>,
    #[account(mut)]
    pub group_vault: Account<'info, TokenAccount>,
    #[account(mut)]
    pub group_save: Account<'info, GroupSave>,
    /// CHECK: PDA authority for vault
    pub vault_authority: AccountInfo<'info>,
    pub token_program: Program<'info, Token>,
}

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

// Goal Save Account
#[account]
pub struct GoalSave {
    pub owner: Pubkey,
    pub purpose: String,
    pub category: String,
    pub target_amount: u64,
    pub contributed: u64,
    pub frequency: String, // daily/weekly/monthly/manual
    pub start_ts: u64,
    pub end_ts: u64,
    pub status: u8, // 0 = live, 1 = completed
}

// Group Save Account
#[account]
pub struct GroupSave {
    pub group_code: String,
    pub is_public: bool,
    pub description: String,
    pub creator: Pubkey,
    pub category: String,
    pub target_amount: u64,
    pub contributed: u64,
    pub frequency: String,
    pub start_ts: u64,
    pub end_ts: u64,
    pub members: Vec<Pubkey>,
    pub status: u8, // 0 = live, 1 = completed
}

// Events for transaction history
#[event]
pub struct DepositEvent {
    pub user: Pubkey,
    pub amount: u64,
    pub plan: String,
}

#[event]
pub struct WithdrawEvent {
    pub user: Pubkey,
    pub amount: u64,
    pub plan: String,
}

#[event]
pub struct CreateGoalEvent {
    pub user: Pubkey,
    pub goal: String,
    pub target: u64,
}

#[event]
pub struct CreateGroupEvent {
    pub user: Pubkey,
    pub group_code: String,
    pub target: u64,
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
    #[msg("Goal not completed")]
    GoalNotCompleted,
    #[msg("Group not completed")]
    GroupNotCompleted,
}
