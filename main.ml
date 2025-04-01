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
let ast = Parser.input Lexer.main lexbuf 

let result = eval ast []

let _ = Printf.printf "Parse:\n%s\n" (Ast.as_string ast);
 Printf.printf "Eval:\n%s\n" (string_of_bool result);
