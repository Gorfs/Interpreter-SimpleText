open Ast

let lexbuf = Lexing.from_channel stdin 

(* let rec eval x lst = match x with  
  | Var a -> snd(List.find(fun (x, _) -> x = a) lst)
  | True -> true
  | False -> false
  | Or (l, r) -> eval l lst || eval r lst
  | And (l, r) -> eval l lst && eval r lst
  | Let (bindings, expr) -> 
      let rec bindings_str str =
        match str with
        | [] -> []
        | (a,b)::[] -> [(a, eval b lst)]
        | (a,b)::c -> (a, eval b lst) :: bindings_str c
      in
      let new_lst = bindings_str bindings in
      eval expr (new_lst @ lst)
  | Assignment (x,y) -> 
    eval x lst  = eval y lst 
  | Not (l) -> not (eval l lst)
  | If (e1, e2, e3) -> 
    if eval e1 lst then eval e2 lst else eval e3 lst
*)


(* try and catch error *)


let ast = 
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
    
let result = document_to_string ast 

let _ = Printf.printf "Parse:\n%s\n" result;
