(* Ast.ml fichier pour cree les types de l'arbre de syntaxe abstraite *)

type  texte_rich = 
| Texte_gras of string list
| Texte_italique of string list
| Texte_rich of string list
| Mot of string

type  definition = Definition of string * (string list)

type  texte_couleur =
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

type document = Document of corps 
