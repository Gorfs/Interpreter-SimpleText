type var = string


type expression =
  | Var of var 
  | True
  | False
  | Or of expression * expression
  | And of expression * expression
  | Assignment of expression * expression
  | Let of (var * expression ) list * expression
  | Not of expression
  | If of expression * expression * expression



let rec as_string = function
  | Var x -> x
  | True -> "true"
  | False -> "false"
  | Assignment (x,y) -> as_string y ^ "=" ^ as_string x
  | Or (l, r) -> apply "\\/" l r
  | And (l, r) -> apply "/\\" l r
  | Not (l) -> "not (" ^ as_string l ^ ")"
  | If (e1, e2, e3) -> 
    "if " ^ as_string e1 ^ " then " ^ as_string e2 ^ " else " ^ as_string e3
  | Let (bindings, expr) ->
      let rec bindings_str str =
        match str with
        | [] -> ""
        | (a,b)::[] -> a ^ " = " ^ as_string b 
        | (a,b)::c ->  a ^ " = " ^ as_string b ^ " and " ^ bindings_str c
      in
       "let " ^ bindings_str bindings ^ " in " ^ as_string expr

and apply op l r = 
  "(" ^ as_string l ^ ") " ^ op ^ " (" ^ as_string r ^ ")"
