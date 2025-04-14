open Ast
open Macros


(* Fonction pour convertir les mot individuelle en string, avec remplacement macro *)
let mot_to_string mot = 
  (* on regarder si le mot commence par "\\"*)
  if String.length mot > 0 && mot.[0] = '\\' then
  (* on donne le remplacement *)

    (* avant on enlever les backslash mais au final pas besoin *)
  (*let mot = String.sub mot 1 (String.length mot - 1) in*)

  let remplacement = get_definition mot in
  match remplacement with
  | [] ->raise(Failure ("Erreur: le macro " ^ mot ^ " n'existe pas")) 
  | a -> List.fold_left (fun acc x -> acc ^ " " ^ x) "" a

    else
    mot


(* Fonctions pour convertir une ast en string/document HTML  *)
let rec mot_list_to_string = function
  | [] -> ""
  | [x] -> (mot_to_string x) 
  | [x; y] -> (mot_to_string x) ^ " " ^ (mot_to_string y) 
  | x::xs -> (mot_to_string x) ^ " " ^ (mot_list_to_string xs)

let texte_rich_to_string = function
  | Texte_gras ms -> "<b>" ^ (mot_list_to_string ms) ^ "</b>"
  | Texte_italique ms -> "<i>" ^ (mot_list_to_string ms) ^ "</i>"
  | Texte_rich ms -> "<b><i>" ^ (mot_list_to_string ms) ^ "</i></b>"
  | Mot m -> mot_list_to_string [m]

let texte_couleur_to_string = function
  | Texte_couleur (cc, ms) -> "<span style=\"color: #" ^ cc ^ ";\">" ^ String.concat " " (List.map texte_rich_to_string ms) ^ "</span>"
  | Texte_sans_couleur ms -> texte_rich_to_string ms

let texte_lien_to_string = function
  | Texte_lien (ms, url) -> "<a href=\"" ^ url ^ "\">" ^ String.concat " " (List.map texte_couleur_to_string ms) ^ "</a>"
  | Texte_sans_lien ms -> texte_couleur_to_string ms

let texte_to_string (Texte elements) =
  String.concat " " (List.map texte_lien_to_string elements)

let item_to_string (Item texte) = 
  "<li>" ^ (texte_to_string texte) ^ "</li>"

let rec element_to_string = function
  | Titre texte -> "<h1>" ^ (texte_to_string texte) ^ "</h1>"
  | Sous_titre texte -> "<h2>" ^ (texte_to_string texte) ^ "</h2>"
  | Paragraphe texte -> "<p>" ^ (texte_to_string texte) ^ "</p>"
  | Liste items -> "<ul>" ^ (String.concat "" (List.map item_to_string items)) ^ "</ul>"
  | Liste_imbriquee corps -> "<ul>" ^ "<li>" ^ (corps_to_string corps) ^ "</li>" ^ "</ul>"

and corps_to_string (Corps elements) =
  String.concat "" (List.map element_to_string elements)

let document_to_string (Document doc) =
  "<html><body>" ^ (corps_to_string doc) ^ "</body></html>"

let ast_to_string ast =
  match ast with
  | Document doc -> document_to_string (Document doc)


(* Main function *)
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

let _ = Printf.printf "Definitions:\n%s\n" (String.concat "\n" (List.map (fun (k, v) -> k ^ " : " ^ String.concat ", " v) (StringMap.bindings definitions)))
  let _ = Printf.printf "Parse:\n%s\n" result 
