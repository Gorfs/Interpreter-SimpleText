{
open Parser
}

let layout = [ ' ' '\t' '\n' ]
let ident_char = [^ ' ' '\t' '*' '\\' '\n' '#' '(' ')' '[' ']' '{' '}']
let hexa_char = ['0'-'9' 'A'-'F' 'a'-'f']

rule main = parse
  | layout		{ main lexbuf }
  | "##" { SUBTITLE }
  | '#' { TITLE }
  | "**" { BOLD }
  | "*" { ITALIC }
  | "\\item" { ITEM }
  | "(" { LPAREN }
  | ")" { RPAREN }
  | "[" { LBRACKET }
  | "]" { RBRACKET }
  | "}{" { LRBRACE }
  | "{" { LBRACE }
  | "}" { RBRACE }
  | "\n\n" { NEWLINE } 
  | "\\color{" { COLOR }
  | hexa_char hexa_char hexa_char hexa_char hexa_char hexa_char { COLOR_CODE (Lexing.lexeme lexbuf) }
  | ident_char+		{ MOT (Lexing.lexeme lexbuf) }
  | eof			{ EOF }
  | _			{ failwith "unexpected character" }
