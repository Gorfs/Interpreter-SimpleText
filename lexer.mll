{
open Parser
}

let layout = [ ' ' '\t' '\n' ]
let ident_char = [ 'a'-'z' ]

rule main = parse
  | layout		{ main lexbuf }
  | "*" { STAR }
  | "\\item" { ITEM }
  | "#" { HASH }
  | "{" { LBRACE }
  | "}" { RBRACE }
  | "[" { LBRACK }
  | "]" { RBRACK }
  | "\n\n" { NEWLINE }
  | ident_char+		{ MOT (Lexing.lexeme lexbuf) }
  | eof			{ EOF }
  | _			{ failwith "unexpected character" }
