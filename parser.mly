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
  | e=element nonempty_list(NEWLINE) b=corps { Corps (e , b) }
  | e=element  { Corps_sing (e) }

element:
  | TITLE e=texte { Titre e }
  | SUBTITLE e=texte { Sous_titre e }
  | e=nonempty_list(item) { Liste e }  
  | e=texte { Paragraphe e }

item:
  | ITEM e=texte { Item e}

string:
  | e=MOT { e }

texte:
  | e=element_de_texte { Texte(e, Texte_vide) }
  | e=element_de_texte e2=texte { Texte(e,e2) }

(* j'ai hésité entre faire ça du côté du parser ou du lexer, mais je trouve ça plus logique de faire ça du côté du lexer *)
color_code:
  | e=COLOR_CODE { e }

element_de_texte:
  | BOLD e=list(string) BOLD { Mot_gras e }
  | ITALIC e=list(string) ITALIC { Mot_italique e }
  | LBRACKET e=list(string) RBRACKET LPAREN e2=string RPAREN { Mot_lien (e,e2) }
  | COLOR e=color_code LRBRACE e2=list(string) RBRACE { Color (e,e2) }
  | e=COLOR_CODE { Code_couleur e }
  | e=MOT { Mot e }