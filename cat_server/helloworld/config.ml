open Mirage

let main = foreign "Unikernel.Main" (console @-> job)

let () = register "hello" [
  main $ default_console
]
