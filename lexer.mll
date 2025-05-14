{
  open Parser
}

let layout = [ ' ' '\t' '\n' ]
let ident_char = [^ ' ' '\t' '*' '\n' '(' ')' '[' ']' '{' '}' ] 
let hexa_char = ['0'-'9' 'A'-'F' 'a'-'f']

rule main = parse
  | layout		{ main lexbuf }
  | "##" { SUBTITLE }
  | "#" { TITLE }
  | "***" { RICH }
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
  | "\\define{" {DEFINE}
  | "\\color{" { COLOR }
  | "\\begindocument" { BEGINDOC }
  | "\\enddocument" { ENDDOC }
  | "\n\n" { NEWLINE } 
  (* | "#" hexa_char hexa_char hexa_char hexa_char hexa_char hexa_char { COLOR_CODE (Lexing.lexeme lexbuf) } *) (* j'ai decider de laisser n'importe dans le span des couleurs comme le span peut accepter plein de format different*)
  | ident_char+		{ MOT (Lexing.lexeme lexbuf) }
  | eof			{ EOF }
  | _			{ failwith "unexpected character" }
