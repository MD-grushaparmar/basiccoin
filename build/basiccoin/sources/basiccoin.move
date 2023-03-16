module Addr::basiccoin{
    use std::signer;
    use std::error;
    

    const ENO_MESSAGE: u64 = 0;
    const EINSUFFICIENT_BALANCE: u64 = 1;
    struct Coin has key{
        value: u64,
    }
    
    // public fun publish_balance<CoinType>(account: &signer){
    //     let empty_coin = Coin<CoinType>{value:0};
    //     assert!(!exists<Balance<CoinType>>(signer::address_of(account)),EALREADY_HAS_BALANCE);
    //     move_to(account,Balance<CoinType>{coin: empty_coin});
    // }
    public entry fun mint(mint_addr: address, amount: u64) acquires Coin{
       // move_to(&account,Coin{ value})
       //assert!(signer::address_of(module_owner)==MODULE_OWNER, ENOT_MODULE_OWNER);
       deposit(mint_addr,Coin{value: amount});
    }
    #[view]
    public fun balance_of(owner: address): u64 acquires Coin{
       // borrow_global<Balance<CoinType>>(owner).coin.value
        assert!(exists<Coin>(owner),error::not_found(ENO_MESSAGE));

        *&borrow_global<Coin>(owner).value
    }
    public entry fun set_coin(account: address, val:u64) acquires Coin{
        let balance_ref = &mut borrow_global_mut<Coin>(account).value;
        *balance_ref = val;
        // *balance_ref = balance + value;
    }
    
    public entry fun transfer(from: &signer, to : address, amount: u64) acquires Coin{
        let check = withdraw(signer::address_of(from),amount);
        deposit(to,check);
    }
    
    fun withdraw(addr:address, amount:u64):Coin acquires Coin{
        let balance = balance_of(addr);
        assert!(balance >= amount,EINSUFFICIENT_BALANCE);
        let balance_ref = &mut borrow_global_mut<Coin>(addr).value;
        *balance_ref = balance - amount;
        Coin{value:amount}
    }
    fun deposit(addr: address,check:Coin) acquires Coin{
        let balance = balance_of(addr);
        let balance_ref = &mut borrow_global_mut<Coin>(addr).value;
        let Coin{ value } = check;
        *balance_ref = balance + value;
    }
    
    
}