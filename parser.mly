%{
open Ast
%}

// %token STAR ITEM NEWLINE EOF HASH LBRACKET RBRACKET LPAREN RPAREN
%token EOF HASH NEWLINE STAR //RPAREN LPAREN LBRACKET RBRACKET
%token<string> MOT 

%start<Ast.document> input

%right STAR

%%
input: c=document { c }



document:
  | e=corps EOF { Document e }

corps:
  | e=element NEWLINE NEWLINE b=corps { Corps (e , b) }
  | e=element  { Corps_sing (e) }

element:
  | HASH e=texte { Titre e }
  | HASH HASH e=texte { Sous_titre e }
  | e=texte { Paragraphe e }
  // | b=item c=element { Liste [b; c] }
// item:
//   | ITEM e=texte { Item e }
texte:
  | e=element_de_texte { Texte(e, Texte_vide) }
  | e=element_de_texte e2=texte { Texte(e,e2) }

element_de_texte:
  | e=mot { e }
  | STAR e=element_de_texte STAR { Mot_italique e }
  | STAR STAR e=element_de_texte STAR STAR  { Mot_gras e }
  // | LBRACKET e=list(mot) RBRACKET LPAREN e2=mot RPAREN { Mot_lien (e,e2) }

// liste_mots:
//   | e=mot { [e] }
//   | e=mot; e2=liste_mots { e :: e2}

mot:
 |e = MOT { Mot e} 

  