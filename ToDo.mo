import Map "mo:base/HashMap";
import Hash "mo:base/Hash"; 
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Text "mo:base/Text";

actor Assistant{

   type ToDo = {
      description: Text;
      completed: Bool;
   };

   func natHash(n: Nat) : Hash.Hash {
      Text.hash(Nat.toText(n))
   };

   var toDoList = Map.HashMap<Nat, ToDo>(0,Nat.equal,natHash);
   var nextId: Nat = 0;

   public func addToDo(description: Text) : async Nat {
      let id = nextId;
      toDoList.put(id, {description: description ; completed = false});
      nextId += 1;
      id
   };

   public query func getToDoList() : async [ToDo] {
      Iter.toArray(toDoList.vals());
   };

   public func completeToDo(id: Nat) : async () {
      ignore do ? {
         let description = toDoList.get(id)!.description;
         toDoList.put(id, {description; completed = true});
      }
   };

   public query func showToDoList() : async Txt {
      var output: Text = "\n___To-Do___";
      for (todo: ToDo in todos.vals()) {
         output #= "\n" #todo.description;
         if (todo.completed) { output #= " +"};
      };
      output # "\n";
   };

   public func clearCompleted() : async {
      toDoList := Map.mapFiller<>(toDoList, NAt.equaş, natHash,
         func(_,todo) {if (todo.completed) null else ?todo});
   }
};