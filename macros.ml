(* Code pour stocker les definitions a remplacer *)
    
module StringMap = Map.Make(String)

type map = string list StringMap.t

let def_map : map ref = ref StringMap.empty

let get_definition cle =  
  try
    StringMap.find cle !def_map
  with Not_found -> []

let add_definition cle valeur =
  (* on verifie si la cle est deja pris*)
  if get_definition cle <> [] then
    raise (Failure ("Erreur: la cle " ^ cle ^ " existe deja"))
  else
    def_map := StringMap.add cle valeur !def_map


let clear_definitions () =  
  def_map := StringMap.empty


(*recuperer tous les definitions*)
let get_definitions () = !def_map
    



