{
open Parser
}

let layout = [ ' ' '\t' '\n' ]
let ident_char = [ 'a'-'z' ]

rule main = parse
  | layout		{ main lexbuf }
  | ')'			{ RPAREN }
  | '('			{ LPAREN }
  | "\\/"			{ OR }
  | "/\\"     { AND }
  | "false"		{ FALSE }
  | "true"		{ TRUE }
  | "let"     { LET }
  | "="       { ASSIGNMENT }
  | "in"      { IN }
  | "and"     { AND_KW }
  | "~"     { NOT }
  | "if"   { IF }
  | "then" { THEN }
  | "else" { ELSE }
  | ident_char+		{ ID (Lexing.lexeme lexbuf) }
  | eof			{ EOF }
  | _			{ failwith "unexpected character" }
