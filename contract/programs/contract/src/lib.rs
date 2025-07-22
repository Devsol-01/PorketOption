use anchor_lang::prelude::*;

declare_id!("2AmsYgcLobdupv7Z9idFFaoNATc98Eqn1f7kE4F6RvyK");

#[program]
pub mod contract {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        msg!("Greetings from: {:?}", ctx.program_id);
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Initialize {}
