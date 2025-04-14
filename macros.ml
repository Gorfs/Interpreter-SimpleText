(* Code pour stocker les definitions a remplacer *)
    
module StringMap = Map.Make(String)

type map = string list StringMap.t

let def_map : map ref = ref StringMap.empty

(* ajouter une definition a la map *)
let add_definition cle valeur =
  def_map := StringMap.add cle valeur !def_map

let get_definition cle =  
  try
    StringMap.find cle !def_map
  with Not_found -> []

let clear_definitions () =  
  def_map := StringMap.empty


(*recuperer tous les definitions*)
let get_definitions () = !def_map
    



