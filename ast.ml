
type texte_rich = 
| Texte_gras of string list
| Texte_italique of string list
| Texte_rich of string list
| Mot of string

type texte_couleur =
| Texte_couleur of string * texte_rich list
| Texte_sans_couleur of texte_rich

type texte_lien =
| Texte_lien of texte_couleur list * string
| Texte_sans_lien of texte_couleur

type texte = 
| Texte of texte_lien list

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

type definition =  Definition of string * (string list)


type document = Document of corps * definition list 

let definition_to_string = function
  | (_,b) -> b
    

let rec mot_list_to_string = function
  | [] -> ""
  | [x] -> x
  | [x; y] -> x ^ " " ^ y
  | x::xs -> x ^ " " ^ (mot_list_to_string xs)

let texte_rich_to_string = function
  | Texte_gras ms -> "<b>" ^ (mot_list_to_string ms) ^ "</b>"
  | Texte_italique ms -> "<i>" ^ (mot_list_to_string ms) ^ "</i>"
  | Texte_rich ms -> "<b><i>" ^ (mot_list_to_string ms) ^ "</i></b>"
  | Mot m -> m

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

let document_to_string (Document (doc, _)) =
  "<html><body>" ^ (corps_to_string doc) ^ "</body></html>"


