{
open Parser
}

let layout = [ ' ' '\t' ]
let ident_char = [^ ' ' '\t' '\n' '*' '\\' '#' '{' '}' '[' ']' ]

rule main = parse
  | layout		{ main lexbuf }
  | '#' { HASH }
  | "*" { STAR } 
   (* | "\\item" { ITEM } *)
  (* | "{" { LBRACE } *)
  (* | "}" { RBRACE } *)
  (* | "[" { LBRACK } *)
  (* | "]" { RBRACK }  *)
  | '\n' { NEWLINE } 
  | ident_char+		{ MOT (Lexing.lexeme lexbuf) }
  | eof			{ EOF }
  | _			{ failwith "unexpected character" }
