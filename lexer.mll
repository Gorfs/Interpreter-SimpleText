{
open Parser
}

let layout = [ ' ' '\t' '\n' ]
let ident_char = [^ ' ' '\t' '*' '\\' '\n' '#' '(' ')' '[' ']' ]

rule main = parse
  | layout		{ main lexbuf }
  | '#' { HASH }
  | "*" { STAR } 
  | "\\item" { ITEM }
  | "(" { LPAREN }
  | ")" { RPAREN }
  | "[" { LBRACKET }
  | "]" { RBRACKET } 
  | "\n\n" { NEWLINE } 
  | ident_char+		{ MOT (Lexing.lexeme lexbuf) }
  | eof			{ EOF }
  | _			{ failwith "unexpected character" }
