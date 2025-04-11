type element_de_texte = 
  | Mot of string
  | Mot_gras of string list 
  | Mot_italique of string list 
  | Mot_lien of (string list) * string
  | Color of string * (string list)

type texte = 
| Texte of element_de_texte list

type item = Item of texte

type item_list = 
| Liste_item of item list

type element = 
| Titre of texte
| Sous_titre of texte
| Paragraphe of texte
| Liste of item list
| Liste_imbriquee of corps

and corps =
|  Corps of element list

type document = Document of corps 

let rec mot_list_to_string = function
  | [] -> ""
  | [x] -> x
  | [x; y] -> x ^ " " ^ y
  | x::xs -> x ^ " " ^ (mot_list_to_string xs)

let element_de_texte_to_string = function
  | Mot m -> m
  | Mot_gras ms -> "<b>" ^ (mot_list_to_string ms) ^ "</b>"
  | Mot_italique ms -> "<i>" ^ (mot_list_to_string ms) ^ "</i>"
  | Mot_lien (ms, url) -> "<a href=\"" ^ url ^ "\">" ^ (mot_list_to_string ms) ^ "</a>"
  | Color (cc, ms) -> "<span style=\"color: #" ^ cc ^ ";\">" ^ (mot_list_to_string ms) ^ "</span>"

let texte_to_string (Texte elements) =
  String.concat " " (List.map element_de_texte_to_string elements)

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


