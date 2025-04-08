%{
open Ast
%}

// %token STAR ITEM NEWLINE EOF HASH LBRACKET RBRACKET LPAREN RPAREN
%token EOF HASH NEWLINE STAR ITEM RPAREN LPAREN LBRACKET RBRACKET
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
  | STAR STAR e=nonempty_list(string) STAR STAR { Mot_gras e }
  | STAR e=nonempty_list(string) STAR { Mot_italique e }
  | LBRACKET e=nonempty_list(string) RBRACKET LPAREN e2=string RPAREN { Mot_lien (e,e2) }
  | LBRACKET e=nonempty_list(string) RBRACKET { Mot_crochets e }
  | LPAREN e=nonempty_list(string) RPAREN { Mot_parentheses e }
  | e=mot { e }

mot:
  | e=MOT { Mot e }
  | LBRACKET { Mot "["} 
  | RBRACKET { Mot "]"}
  | LPAREN { Mot "("}
  | RPAREN { Mot ")"}