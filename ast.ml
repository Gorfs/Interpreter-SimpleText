
type element_de_texte = 
  | Mot of string 
  | Mot_gras of (string list) 
  | Mot_italique of (string list) 
  | Mot_lien of  (string list) * string

type texte = Texte of (element_de_texte list)

type item = Item of texte

type element = 
| Titre of texte
| Sous_titre of texte
| Paragraphe of texte 
| Liste of (item list) 

type corps = Corps of (element list)

type document = Document of element_de_texte 



let element_de_texte_to_string = function
  | Mot m ->  m 
  | Mot_gras ms -> "<b>" ^ (String.concat " " ms) ^ "</b>"
  | Mot_italique ms -> "<i>" ^ (String.concat " " ms) ^ "</i>"
  | Mot_lien (ms, url) -> "<a href=\"" ^ url ^ "\">" ^ (String.concat " " ms) ^ "</a>"

let texte_to_string (Texte elements) =
  String.concat " " (List.map element_de_texte_to_string elements)
let item_to_string (Item texte) = texte_to_string texte
let element_to_string = function
  | Titre texte -> "<h1>" ^ (texte_to_string texte) ^ "</h1>"
  | Sous_titre texte -> "<h2>" ^ (texte_to_string texte) ^ "</h2>"
  | Paragraphe texte -> "<p>" ^ (texte_to_string texte) ^ "</p>"
  | Liste items -> "<ul>" ^ (String.concat "" (List.map (fun item -> "<li>" ^ (item_to_string item) ^ "</li>") items)) ^ "</ul>"

let corps_to_string (Corps elements) =
  String.concat "\n" (List.map element_to_string elements)
let document_to_string (Document corps) =
  "<html><body>" ^ (corps_to_string corps) ^ "</body></html>"


