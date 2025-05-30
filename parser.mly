%{
open Ast
open Macros
%}


%token EOF TITLE SUBTITLE NEWLINE ITALIC BOLD RICH ITEM RPAREN LPAREN LBRACKET RBRACKET COLOR LBRACE RBRACE LRBRACE BEGINDOC ENDDOC DEFINE TRUE FALSE BOOLEAN IF
%token<string> MOT 
%start<Ast.document> input
%%
input: c=document { c }
boolean: 
  | TRUE { true }
  | FALSE { false }

document:
  | list(definition) BEGINDOC option(NEWLINE) e=corps ENDDOC option(NEWLINE) list(MOT) EOF { Document (e) }
  // gestion fichier vide / sans contenu
  | EOF { Document (Corps []) }

definition:
  | DEFINE word=MOT LRBRACE option(TITLE)  (*title possible pour le hex*) replacement=texte RBRACE { add_definition word (replacement); () }
  | BOOLEAN word=MOT LRBRACE replacement=boolean RBRACE { add_boolean word (replacement); ()}

corps:
  | e=element nonempty_list(NEWLINE) b=corps { 
      match b with
      | Corps elems -> Corps (e :: elems)
    }
  | e=element option(NEWLINE) { Corps [e] }

element:
  | TITLE e=texte { Titre e }
  | SUBTITLE e=texte { Sous_titre e }
  | e=nonempty_list(item) { Liste e }
  | ITEM LBRACE e=corps RBRACE { Liste_imbriquee e }
  | IF element=MOT LBRACE e=corps RBRACE { If_condition (element, e) } 
  | e=texte { Paragraphe e }

item:
  | ITEM e=texte { Item e}

texte:
  | es=nonempty_list(texte_lien) { Texte es }

texte_lien:
  | LBRACKET e=list(texte_couleur) RBRACKET LPAREN e2=MOT RPAREN { Texte_lien (e,e2) }
  | e=texte_couleur { Texte_sans_lien e }

texte_couleur:
  | COLOR option(TITLE) e=MOT LRBRACE e2=list(texte_rich) RBRACE { Texte_couleur (e, e2) }
  | e=texte_rich { Texte_sans_couleur e }

texte_rich:
  | BOLD e=list(MOT) BOLD { Texte_gras e }
  | ITALIC e=list(MOT) ITALIC { Texte_italique e }
  | RICH e=list(MOT) RICH {Texte_rich e }
  | RICH e=list(MOT) ITALIC e1=list(MOT) BOLD  { Texte_bizarre_bold_last (e , e1) }
  | RICH e=list(MOT) BOLD e1=list(MOT) ITALIC { Texte_bizarre_italic_last (e , e1) }
  | BOLD e=list(MOT) ITALIC e1=list(MOT) RICH { Texte_bizarre_bold_first (e, e1) }
  | ITALIC e=list(MOT) BOLD e1=list(MOT) RICH { (Texte_bizarre_italic_first (e, e1)) }
  | e=MOT {Mot e}
