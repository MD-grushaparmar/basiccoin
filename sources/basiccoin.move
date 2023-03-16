module Addr::basiccoin{
    use std::signer;
    use std::error;
    

    const ENO_MESSAGE: u64 = 0;
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
    public entry fun set_coin(account: signer, val:u64){
        let account_addr = signer::address_of(&account);
        if(!exists<Coin>(account_addr)){
            move_to(&account,Coin{value:val})
        }
    }
    
    // public fun transfer<CoinType: drop>(from: &signer, to : address, amount: u64,_witness: CoinType) acquires Balance{
    //     let check = withdraw<CoinType>(signer::address_of(from),amount);
    //     deposit<CoinType>(to,check);
    // }
    
    // fun withdraw<CoinType>(addr:address, amount:u64):Coin<CoinType> acquires Balance{
    //     let balance = balance_of<CoinType>(addr);
    //     assert!(balance >= amount,EINSUFFICIENT_BALANCE);
    //     let balance_ref = &mut borrow_global_mut<Balance<CoinType>>(addr).coin.value;
    //     *balance_ref = balance - amount;
    //     Coin<CoinType>{value:amount}
    // }
    fun deposit(addr: address,check:Coin) acquires Coin{
        let balance = balance_of(addr);
        let balance_ref = &mut borrow_global_mut<Coin>(addr).value;
        let Coin{ value } = check;
        *balance_ref = balance + value;
    }
    
    
}