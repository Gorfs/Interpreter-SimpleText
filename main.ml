open Ast
open Macros

(* Fonction pour convertir les mot individuelle en string, avec remplacement macro *)
let rec mot_to_string mot = 
  (* on regarder si le mot commence par "\\"*)
  if String.length mot > 0 && mot.[0] = '\\' then
    (* on regarde si le mot est une macro *)  
    (* print mot *)
    let _ = Printf.printf "mot: %s\n" mot in
    let remplacement = get_definition mot in
    match remplacement with
    | Texte [] -> 
      (* si la macro n'existe pas, on renvoie le mot tel quel *)
      let _ = Printf.printf "pas de remplacement : %s\n" mot in
      raise(Failure("Erreur: la macro " ^ mot ^ " n'existe pas"))
    | a -> let _ = Printf.printf "remplacement : %s\n" (texte_to_string a) in 
      texte_to_string a
  else
    mot

(* Fonctions pour convertir une ast en string/document HTML  *)
and mot_list_to_string = function
  | [] -> ""
  | [x] -> (mot_to_string x) 
  | [x; y] -> (mot_to_string x) ^ " " ^ (mot_to_string y) 
  | x::xs -> (mot_to_string x) ^ " " ^ (mot_list_to_string xs)

and texte_rich_to_string = function
  | Texte_gras ms -> "<b>" ^ (mot_list_to_string ms) ^ "</b>"
  | Texte_italique ms -> "<i>" ^ (mot_list_to_string ms) ^ "</i>"
  | Texte_rich ms -> "<b><i>" ^ (mot_list_to_string ms) ^ "</i></b>"
  | Mot m -> mot_list_to_string [m]


and texte_couleur_to_string = function
  | Texte_couleur (cc, ms) -> 
      let color_code = if String.length cc > 0 && cc.[0] = '\\' then
        (* si c'est un macro alors on prend ca def *)
        let remplacement = get_definition cc in
        match remplacement with
        | Texte [Texte_sans_lien (Texte_sans_couleur (Mot code))] -> code
        | _ -> "000000" 
      else 
        cc 
      in
      "<span style=\"color:" ^ color_code ^ ";\">" ^ 
      String.concat " " (List.map texte_rich_to_string ms) ^ "</span>"
  | Texte_sans_couleur ms -> texte_rich_to_string ms

and texte_lien_to_string = function
  | Texte_lien (ms, url) -> "<a href=\"" ^ url ^ "\">" ^ String.concat " " (List.map texte_couleur_to_string ms) ^ "</a>"
  | Texte_sans_lien ms -> texte_couleur_to_string ms

and texte_to_string (Texte elements) =
  String.concat " " (List.map texte_lien_to_string elements)

and item_to_string (Item texte) = 
  "<li>" ^ (texte_to_string texte) ^ "</li>"

let rec element_to_string = function
  | Titre texte -> "<h1>" ^ (texte_to_string texte) ^ "</h1>"
  | Sous_titre texte -> "<h2>" ^ (texte_to_string texte) ^ "</h2>"
  | Paragraphe texte -> "<p>" ^ (texte_to_string texte) ^ "</p>"
  | Liste items -> "<ul>" ^ (String.concat "" (List.map item_to_string items)) ^ "</ul>"
  | Liste_imbriquee corps -> "<ul>" ^ "<li>" ^ (corps_to_string corps) ^ "</li>" ^ "</ul>"
  | If_condition (condition_name, value) -> 
      let condition_value = get_boolean condition_name in
      if condition_value then  (corps_to_string value) else ""

and corps_to_string (Corps elements) =
  String.concat "" (List.map element_to_string elements)

let document_to_string (Document doc) =
  "<html><body>" ^ (corps_to_string doc) ^ "</body></html>"

let ast_to_string ast =
  match ast with
  | Document doc -> document_to_string (Document doc)


let lexbuf = Lexing.from_channel stdin 
let ast = 
  begin 
    try
      Parser.input Lexer.main lexbuf 
    with 
      | e ->
      let pos = Lexing.lexeme_start_p lexbuf in
      let column = pos.pos_cnum - pos.pos_bol in
      let char = Lexing.lexeme lexbuf in
      Printf.printf "Error : %s\n" (Printexc.to_string e);
      Printf.printf "Error at column %d: unexpected character '%s'\n" column char;
      exit 1 
    end
let definitions = get_definitions () 

let result = ast_to_string (ast) 
(* fonction pour print les definition. utiliser pour le debug *)
(* let _ =  *)
  (* Printf.printf "Definitions:\n"; *)
  (* StringMap.iter (fun k v -> Printf.printf "%s: %s\n" k (texte_to_string v)) definitions *)
(* Print the result *)
let _ = Printf.printf "%s\n" result
