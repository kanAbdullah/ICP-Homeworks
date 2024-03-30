import Icrc1Ledger "canister:icrc1_ledger_canister";
import Debug "mo:base/Debug";
import Result "mo:base/Result";
import Option "mo:base/Option";
import Blob "mo:base/Blob";
import Error "mo:base/Error";
import Nat8 "mo:base/Nat8";
import Principal "mo:base/Principal";

actor {
  type Account = {
    owner : Principal;
    subAccount : ?[Nat8]
  };

  type TransferArgs = {
    amount : Nat;
    toAccount : Account;
  };

  let transferArgs : Icrc1Ledger.TransferArgs = {
    memo = null;
    amount = args.amount;
    from_subaccount = null;
    fee = null;
    to = args.account;
    created_at_time = null;
  };

try {
  let transferResult = await Icrc1Ledger.icrc1_transfer(transferArgs);

  switch (transferResult) {
    case(#Err(transferError)) {
      #err("Couldn't transfer funds:\n " # debug_show(transferError))
    };
    case (#ok(blockIndex)) {return #ok blockIndex};
  };
} catch (error: Error) {
    #err("Reject message: " # Error.message(error))
  };
}