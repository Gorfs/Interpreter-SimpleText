%{
open Ast
%}

// %token STAR ITEM NEWLINE EOF HASH LBRACKET RBRACKET LPAREN RPAREN
%token EOF HASH NEWLINE STAR ITEM RPAREN LPAREN LBRACKET RBRACKET
%token<string> MOT 

%start<Ast.document> input

// %right STAR

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
  |e=MOT { e }

texte:
  | e=element_de_texte { Texte(e, Texte_vide) }
  | e=element_de_texte e2=texte { Texte(e,e2) }

element_de_texte:
  | e=mot { e }
  | STAR STAR e=nonempty_list(string) STAR STAR  { Mot_gras e }
  | STAR e=nonempty_list(string) STAR { Mot_italique e }
  | LBRACKET e=nonempty_list(string) RBRACKET LPAREN e2=string RPAREN { Mot_lien (e,e2) }

// liste_mots:
//   | e=mot { [e] }
//   | e=mot; e2=liste_mots { e :: e2}

mot:
 |e = MOT { Mot e}

