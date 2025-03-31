
(* The type of tokens. *)

type token = 
  | TRUE
  | THEN
  | RPAREN
  | OR
  | NOT
  | LPAREN
  | LET
  | IN
  | IF
  | ID of (string)
  | FALSE
  | EOF
  | ELSE
  | ASSIGNMENT
  | AND_KW
  | AND

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val input: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.expression)
