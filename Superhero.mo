import List "mo:base/List";
import Option "mo:base/Option";
import Trie "mo:base/Trie";
import Nat32 "mo:base/Nat32";
import Text "mo:base/Text";

actor SuperHeroes{
  public type SuperHeroId = Nat32;

  public type SuperHero = {
    name: Text;
    superPowers: List.List<Text>;

  };


  //Stable 
  private stable var next: SuperHeroId = 0;

  private stable var superHeroes : Trie.Trie<SuperHeroId, SuperHero> = Trie.empty();

  //high level API


  public func create(superHero: SuperHero): async SuperHeroId {
    let superHeroId = next;
    next += 1;
    superHeroes := Trie.replace(
      superHeroes,
      key(superHeroId),
      Nat32.equal,
      ?superHero,
    ).0;
    superHeroId
  };
  
  public func update(superHeroId : SuperHeroId, superHero : SuperHero) : async Bool {
    let result = Trie.find(superHeroes,key(superHeroId), Nat32.equal);
    let exists = Option.isSome(result);
    if(exists) {
      superHeroes := Trie.replace(
        superHeroes,
        key(superHeroId),
        Nat32.equal,
        ?superHero,
      ).0;
    };
    exists
  };

  public query func read(superHeroId: SuperHeroId): async ?SuperHero{
    let result = Trie.find(superHeroes, key(superHeroId), Nat32.equal);
    result
  };

  public func delete(superHeroId: SuperHeroId): async Bool {
    let result = Trie.find(superHeroes, key(superHeroId), Nat32.equal);
    let exists = Option.isSome(result);
    if(exists) {
      superHeroes := Trie.replace(
        superHeroes,
        key(superHeroId),
        Nat32.equal,
        null,
      ).0;
    };
    exists
  };

  private func key(x: SuperHeroId): Trie.Key<SuperHeroId>{
    { hash= x; key = x };
  };
};
