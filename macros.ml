(* Code pour stocker les definitions a remplacer *)
open Ast
    
module StringMap = Map.Make(String)

type map = texte StringMap.t

let def_map : map ref = ref StringMap.empty

let get_definition cle =  
  try
    (* let _ = Printf.printf "get_definition cle:%s\n" cle in *)
    StringMap.find cle !def_map
  with Not_found -> Texte []

let add_definition cle valeur =
  (* on verifie si la cle est deja pris*)
  if get_definition cle <> (Texte []) then
    raise (Failure ("Erreur: la cle " ^ cle ^ " existe deja"))
  else
    def_map := StringMap.add cle valeur !def_map


let clear_definitions () =  
  def_map := StringMap.empty


(*recuperer tous les definitions*)
let get_definitions () = !def_map
    



