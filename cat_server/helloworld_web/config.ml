open Mirage

let main = foreign "Cat_server.Main" (console @-> stackv4 @-> job)

let stack = generic_stackv4 default_console tap0

let () = register "cat-server" [
    main $ default_console $ stack
  ]
