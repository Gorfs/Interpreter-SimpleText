
type mot = string
type element_de_texte = 
  (* | Newline  *)
  | Mot of mot 
  | Mot_gras of element_de_texte 
  | Mot_italique of element_de_texte 
  | Mot_lien of  (element_de_texte list) * element_de_texte 

type texte = 
| Texte of (element_de_texte * texte)
| Texte_vide


type item = Item of texte

type item_list = 
| Liste_item of (item * item_list)
| Liste_vide
 

type element = 
| Titre of texte
| Sous_titre of texte
| Paragraphe of texte 
| Liste of item list

type corps =
|  Corps of (element * corps)
|  Corps_sing of element

type document = Document of corps 



let rec element_de_texte_to_string = function
  | Mot m ->  m 
  | Mot_gras ms -> "<b>" ^ (element_de_texte_to_string ms)  ^ "</b>"
  | Mot_italique ms -> "<i>" ^ (element_de_texte_to_string ms) ^ "</i>"
  | Mot_lien (ms, url) -> "<a href=\"" ^  (element_de_texte_to_string url) ^ "\">" ^ (String.concat " "  (List.map element_de_texte_to_string ms)) ^ "</a>"

let rec texte_to_string = function
  | Texte (e, t) -> (element_de_texte_to_string e) ^ (texte_to_string t)
  | Texte_vide -> ""

let item_to_string (Item texte) = 
  "<li>" ^ (texte_to_string texte) ^ "</li>"


let element_to_string = function
  | Titre texte -> "<h1>" ^ (texte_to_string texte) ^ "</h1>"
  | Sous_titre texte -> "<h2>" ^ (texte_to_string texte) ^ "</h2>"
  | Paragraphe texte -> "<p>" ^ (texte_to_string texte) ^ "</p>"
  | Liste items -> "<ul>" ^ (String.concat "" (List.map item_to_string items)) ^ "</ul>"


let rec corps_to_string (corps) =
  match corps with 
  | Corps_sing e -> (element_to_string e) 
  | Corps (elmt , corps) -> (element_to_string elmt) ^ "<br/>" ^ (corps_to_string corps)
let document_to_string (Document doc) =
  "<html><body>" ^ (corps_to_string doc) ^ "</body></html>" 


