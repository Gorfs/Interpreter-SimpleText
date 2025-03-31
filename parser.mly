%{
open Ast
%}

%token AND OR LET ASSIGNMENT IN LPAREN RPAREN TRUE FALSE EOF AND_KW NOT IF THEN ELSE
%token<string> ID 

%start<Ast.expression> input


%nonassoc THEN 
%nonassoc ELSE
%nonassoc IN
%nonassoc NOT 
// %nonassoc LET
%right OR
%right AND 
%%

  
input: c=expression EOF { c }

expression:
  | x=ID  { Var x }
  | l=expression AND r=expression { And (l, r)}
  | l=expression OR r=expression { Or (l, r) }
  | TRUE { True }
  | FALSE { False }
  | LPAREN c=expression RPAREN { c }
  | LET b1=separated_nonempty_list(AND_KW, definition) IN e2=expression { Let (b1, e2) }
  | NOT e1=expression { Not e1 }
  | IF e1=expression THEN e2=expression ELSE e3=expression { If (e1, e2, e3) }
  | IF e1=expression THEN e2=expression  { If (e1, e2, False) }

definition:
    | x=ID ASSIGNMENT e=expression  { x, e }