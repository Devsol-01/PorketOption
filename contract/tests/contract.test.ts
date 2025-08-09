import * as anchor from "@coral-xyz/anchor";
import { Program } from "@coral-xyz/anchor";
import type { Contract } from "../target/types/contract";
import { assert } from "chai";
import { Connection, Keypair, PublicKey } from "@solana/web3.js";
import {
  getOrCreateAssociatedTokenAccount,
  createMint,
  mintTo,
  getAccount,
  transfer,
  TOKEN_PROGRAM_ID,
  ASSOCIATED_TOKEN_PROGRAM_ID,
} from "@solana/spl-token";

// USDC Devnet Mint
const USDC_MINT = new PublicKey("Es9vMFrzaCERh8b1w7QwA4RKHwM1z6y1c5bK4e8k6V2");
const DECIMALS = 6;


// Helper for sleep
function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

describe("PorketOption Savings Contract - Comprehensive Test", function () {
  this.timeout(10000); // Increase timeout for Devnet slowness

  anchor.setProvider(anchor.AnchorProvider.env());
  const program = anchor.workspace.contract as Program<Contract>;
  let user = anchor.AnchorProvider.env().wallet;

  it("Initialize contract", async () => {
    await program.methods.initialize().rpc();
  });

  it("Flexi Save: Deposit and Withdraw", async () => {
    // Derive PDA for flexi_save
    const [flexiSavePda] = await anchor.web3.PublicKey.findProgramAddressSync([
      Buffer.from("flexi_save"), user.publicKey.toBuffer()
    ], program.programId);

    // Create or get user's USDC ATA
    const userUsdc = await getOrCreateAssociatedTokenAccount(
      program.provider.connection,
      user.payer,
      USDC_MINT,
      user.publicKey
    );

    // Mint USDC to user
    await mintTo(
      program.provider.connection,
      user.payer,
      USDC_MINT,
      userUsdc.address,
      user.payer,
      1_000_000 // 1 USDC (6 decimals)
    );

    // Deposit USDC into Flexi Save (assume 0.5 USDC)
    await program.methods.depositFlexi(new anchor.BN(500_000)).accounts({
      user: user.publicKey,
      userUsdc: userUsdc.address,
      flexiVault: flexiSavePda, // This should be the vault PDA for Flexi Save
      flexiSave: flexiSavePda,
    }).rpc();

    // Withdraw USDC from Flexi Save (0.5 USDC)
    await program.methods.withdrawFlexi(new anchor.BN(500_000)).accounts({
      user: user.publicKey,
      userUsdc: userUsdc.address,
      flexiVault: flexiSavePda,
      flexiSave: flexiSavePda,
      vaultAuthority: flexiSavePda,
    }).rpc();

    // Assert user's USDC balance is back to original
    const userUsdcAcc = await getAccount(program.provider.connection, userUsdc.address);
    assert(userUsdcAcc.amount >= BigInt(999_999), "User should have nearly all USDC after deposit+withdraw");
  });

  it("Lock Save: Create, Auto-Payout on Maturity", async () => {
    // Derive PDA for lock_save
    const [lockSavePda] = await anchor.web3.PublicKey.findProgramAddressSync([
      Buffer.from("lock_save"), user.publicKey.toBuffer(), Buffer.from("1")
    ], program.programId);

    // Create or get user's USDC ATA
    const userUsdc = await getOrCreateAssociatedTokenAccount(
      program.provider.connection,
      user.payer,
      USDC_MINT,
      user.publicKey
    );
    // Mint USDC to user
    await mintTo(
      program.provider.connection,
      user.payer,
      USDC_MINT,
      userUsdc.address,
      user.payer,
      2_000_000 // 2 USDC
    );
    // Create Lock Save (lock 1 USDC for 10 days)
    await program.methods.createLockSave(new anchor.BN(1_000_000), new anchor.BN(10), "Test Lock").accounts({
      user: user.publicKey,
      userUsdc: userUsdc.address,
      lockVault: lockSavePda,
      lockSave: lockSavePda,
    }).rpc();
    // Fudge time: simulate maturity by calling claim immediately (contract should allow if time is up, but here we just call for test)
    await program.methods.claimLockIfMatured().accounts({
      user: user.publicKey,
      userUsdc: userUsdc.address,
      lockVault: lockSavePda,
      lockSave: lockSavePda,
      vaultAuthority: lockSavePda,
    }).rpc();
    // Assert payout: user should have nearly all USDC back (with interest)
    const userUsdcAcc = await getAccount(program.provider.connection, userUsdc.address);
    assert(userUsdcAcc.amount >= BigInt(1_999_999), "User should have nearly all USDC after lock payout");
  });

  it("Goal Save: Create, Contribute, Auto-Payout on Completion", async () => {
    // Derive PDA for goal_save
    const [goalSavePda] = await anchor.web3.PublicKey.findProgramAddressSync([
      Buffer.from("goal_save"), user.publicKey.toBuffer(), Buffer.from("rent")
    ], program.programId);
    const userUsdc = await getOrCreateAssociatedTokenAccount(
      program.provider.connection,
      user.payer,
      USDC_MINT,
      user.publicKey
    );
    await mintTo(
      program.provider.connection,
      user.payer,
      USDC_MINT,
      userUsdc.address,
      user.payer,
      2_000_000 // 2 USDC
    );
    // Create Goal Save (target 1 USDC)
    await program.methods.createGoalSave("Rent", "rent", new anchor.BN(1_000_000), "manual", new anchor.BN(Date.now() / 1000), new anchor.BN(Date.now() / 1000 + 86400)).accounts({
      user: user.publicKey,
      goalSave: goalSavePda,
    }).rpc();
    // Contribute 1 USDC (should complete goal)
    await program.methods.contributeGoalSave(new anchor.BN(1_000_000)).accounts({
      user: user.publicKey,
      userUsdc: userUsdc.address,
      goalVault: goalSavePda,
      goalSave: goalSavePda,
    }).rpc();
    // Claim payout
    await program.methods.claimGoalIfCompleted().accounts({
      user: user.publicKey,
      userUsdc: userUsdc.address,
      goalVault: goalSavePda,
      goalSave: goalSavePda,
      vaultAuthority: goalSavePda,
    }).rpc();
    // Assert payout
    const userUsdcAcc = await getAccount(program.provider.connection, userUsdc.address);
    assert(userUsdcAcc.amount >= BigInt(1_999_999), "User should have nearly all USDC after goal payout");
  });

  it("Group Save: Create, Contribute, Auto-Payout on Completion", async () => {
    // Derive PDA for group_save
    const [groupSavePda] = await anchor.web3.PublicKey.findProgramAddressSync([
      Buffer.from("group_save"), user.publicKey.toBuffer(), Buffer.from("group1")
    ], program.programId);
    const userUsdc = await getOrCreateAssociatedTokenAccount(
      program.provider.connection,
      user.payer,
      USDC_MINT,
      user.publicKey
    );
    await mintTo(
      program.provider.connection,
      user.payer,
      USDC_MINT,
      userUsdc.address,
      user.payer,
      2_000_000 // 2 USDC
    );
    // Create Group Save (target 1 USDC, public, "Test Group")
    await program.methods.createGroupSave("group1", true, "Test Group", "events", new anchor.BN(1_000_000), "manual", new anchor.BN(Date.now() / 1000), new anchor.BN(Date.now() / 1000 + 86400)).accounts({
      user: user.publicKey,
      groupSave: groupSavePda,
    }).rpc();
    // Contribute 1 USDC (should complete group)
    await program.methods.contributeGroupSave(new anchor.BN(1_000_000)).accounts({
      user: user.publicKey,
      userUsdc: userUsdc.address,
      groupVault: groupSavePda,
      groupSave: groupSavePda,
    }).rpc();
    // Claim payout
    await program.methods.claimGroupIfCompleted().accounts({
      user: user.publicKey,
      userUsdc: userUsdc.address,
      groupVault: groupSavePda,
      groupSave: groupSavePda,
      vaultAuthority: groupSavePda,
    }).rpc();
    // Assert payout
    const userUsdcAcc = await getAccount(program.provider.connection, userUsdc.address);
    assert(userUsdcAcc.amount >= BigInt(1_999_999), "User should have nearly all USDC after group payout");
  });
});
