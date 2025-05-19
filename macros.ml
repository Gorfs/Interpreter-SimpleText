(* Code pour stocker les definitions a remplacer *)
open Ast
    
module StringMap = Map.Make(String)

type map = texte StringMap.t

type boolean_map = bool StringMap.t


let def_map : map ref = ref StringMap.empty
let boolean_map : boolean_map ref = ref StringMap.empty


let get_definition cle =  
  try
    (* let _ = Printf.printf "get_definition cle:%s\n" cle in *)
    StringMap.find cle !def_map
  with Not_found ->  raise(Failure ("Erreur: la cle " ^ cle ^ " n'existe pas"))

let get_boolean cle = 
  try
    (* let _ = Printf.printf "get_definition cle:%s\n" cle in *)
    StringMap.find cle !boolean_map
  with Not_found -> raise (Failure ("Erreur: la cle " ^ cle ^ " n'existe pas"))

(*ajouter une definition*)
let add_definition cle valeur =
  (* on verifie si la cle est deja pris*)
  if get_definition cle <> (Texte []) then
    raise (Failure ("Erreur: la cle " ^ cle ^ " existe deja"))
  else
    def_map := StringMap.add cle valeur !def_map

let add_boolean cle value = 
  if StringMap.mem cle !boolean_map then
    (* Key exists - raise error or update it *)
    raise (Failure ("Erreur: la cle " ^ cle ^ " existe deja"))
  else
    (* Key doesn't exist - add it *)
    boolean_map := StringMap.add cle value !boolean_map

(*supprimer une definition*)



let clear_definitions () =  
  def_map := StringMap.empty;
  boolean_map := StringMap.empty

(*recuperer tous les definitions*)
let get_definitions () = !def_map


let get_booleans () = !boolean_map

(*verifier si une definition existe*)




