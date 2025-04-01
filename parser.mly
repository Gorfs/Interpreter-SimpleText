%{
open Ast
%}

%token STAR ITEM NEWLINE EOF HASH LBRACKET RBRACKET LPAREN RPAREN
%token<string> MOT 

%start<Ast.document> input


%%

  
input: c=document { c }

document:
  | e=element_de_texte EOF { Document e }

// corps:
//   | e=element NEWLINE b=corps { e :: b }
//   | e=element { [e] }
// element:
//   | HASH e=texte { Titre e }
//   | HASH HASH e=texte { Sous_titre e }
//   | e=texte { Paragraphe e }
//   | b=item c=element { Liste [b; c] }
// item:
//   | ITEM e=texte { Item e }
// texte:
//   | e=element_de_texte { e }
//   | e=element_de_texte e2=texte { e  }

element_de_texte:
  | e=mot { e }
  | STAR e=mot STAR { Mot_italique e }
  | STAR STAR  e=mot STAR STAR  { Mot_gras e }
  | e=MOT { Mot e }
  | LBRACKET e=liste_mots RBRACKET LPAREN e2=mot RPAREN { Mot_lien (e,e2) }

liste_mots:
  | e=mot { [e] }
  | e=mot; e2=liste_mots { e :: e2}

mot:
 |e = MOT { Mot e} 

  