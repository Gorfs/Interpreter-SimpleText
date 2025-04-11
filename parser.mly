%{
open Ast
%}

%token EOF TITLE SUBTITLE NEWLINE ITALIC BOLD ITEM RPAREN LPAREN LBRACKET RBRACKET COLOR LBRACE RBRACE LRBRACE
%token<string> MOT COLOR_CODE
%start<Ast.document> input
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
  | es=nonempty_list(element_de_texte) { Texte es }

element_de_texte:
  | BOLD e=list(MOT) BOLD { Mot_gras e }
  | ITALIC e=list(MOT) ITALIC { Mot_italique e }
  | LBRACKET e=list(MOT) RBRACKET LPAREN e2=MOT RPAREN { Mot_lien (e,e2) }
  | COLOR e=COLOR_CODE LRBRACE e2=list(MOT) RBRACE { Color (e,e2) }
  | e=MOT { Mot e }
