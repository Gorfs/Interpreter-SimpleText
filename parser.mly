%{
open Ast
%}

// %token STAR ITEM NEWLINE EOF HASH LBRACKET RBRACKET LPAREN RPAREN
%token EOF HASH NEWLINE ITALIC BOLD ITEM RPAREN LPAREN LBRACKET RBRACKET
%token<string> MOT
%start<Ast.document> input
%%
input: c=document { c }



document:
  | e=corps EOF { Document e }

corps:
  | e=element NEWLINE b=corps { Corps (e , b) }
  | e=element  { Corps_sing (e) }

element:
  | HASH e=texte { Titre e }
  | HASH HASH e=texte { Sous_titre e }
  | e=nonempty_list(item) { Liste e }  
  | e=texte { Paragraphe e }

item:
  | ITEM e=texte { Item e}

string:
  | e=MOT { e }

texte:
  | e=element_de_texte { Texte(e, Texte_vide) }
  | e=element_de_texte e2=texte { Texte(e,e2) }

element_de_texte:
  | BOLD e=list(string) BOLD { Mot_gras e }
  | ITALIC e=list(string) ITALIC { Mot_italique e }
  | LBRACKET e=list(string) RBRACKET LPAREN e2=string RPAREN { Mot_lien (e,e2) }
  | e=MOT { Mot e }