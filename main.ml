open Ast
open Macros

let lexbuf = Lexing.from_channel stdin 
let ast = 
  begin 
    try
      Parser.input Lexer.main lexbuf 
    with 
      | e ->
      let pos = Lexing.lexeme_start_p lexbuf in
      let column = pos.pos_cnum - pos.pos_bol in
      let char = Lexing.lexeme lexbuf in
      Printf.printf "Error : %s\n" (Printexc.to_string e);
      Printf.printf "Error at column %d: unexpected character '%s'\n" column char;
      exit 1 
    end
let definitions = get_definitions () 
let result = ast_to_string (ast) 

let _ = Printf.printf "Definitions:\n%s\n" (String.concat "\n" (List.map (fun (k, v) -> k ^ " : " ^ String.concat ", " v) (StringMap.bindings definitions)))
  let _ = Printf.printf "Parse:\n%s\n" result 
