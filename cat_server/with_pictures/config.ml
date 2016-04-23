open Mirage

let main = foreign "Cat_server.Main" (console @-> http @-> kv_ro @-> job)

let pics = crunch "./pics"

let stack = generic_stackv4 default_console tap0

let http = http_server (conduit_direct stack)

let () = register "cat-server" [
    main $ default_console $ http $ pics
  ]
