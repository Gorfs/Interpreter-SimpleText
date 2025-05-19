%{
open Ast
%}

%token EOF TITLE SUBTITLE NEWLINE ITALIC BOLD RICH ITEM RPAREN LPAREN LBRACKET RBRACKET COLOR LBRACE RBRACE LRBRACE
%token<string> MOT COLOR_CODE
%start<Ast.document> input
%right NEWLINE
%%
input: c=document { c }

document:
  | e=corps EOF { Document e }

corps:
  | e=element nonempty_list(NEWLINE) b=corps { 
      match b with
      | Corps elems -> Corps (e :: elems)
    }
  | e=element { Corps [e] }

element:
  | TITLE e=texte { Titre e }
  | SUBTITLE e=texte { Sous_titre e }
  | e=nonempty_list(item) { Liste e }
  | ITEM LBRACE e=corps RBRACE { Liste_imbriquee e }
  | e=texte { Paragraphe e }

item:
  | ITEM e=texte { Item e}

texte:
  | es=list(texte_lien) { Texte es }

texte_lien:
  | LBRACKET e=list(texte_couleur) RBRACKET LPAREN e2=MOT RPAREN { Texte_lien (e,e2) }
  | e=texte_couleur { Texte_sans_lien e }

texte_couleur:
  | COLOR e=COLOR_CODE LRBRACE e2=list(texte_rich) RBRACE { Texte_couleur (e,e2) }
  | e=texte_rich { Texte_sans_couleur e }

texte_rich:
  | BOLD e=list(MOT) BOLD { Texte_gras e }
  | ITALIC e=list(MOT) ITALIC { Texte_italique e }
  | RICH e=list(MOT) RICH {Texte_rich e }
  | e=MOT { Mot e }