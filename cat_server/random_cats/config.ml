open Mirage

let main = foreign "Cat_server.Main" (console @-> http @-> kv_ro @-> job)

let pics = crunch "./pics"

let stack = try match Sys.getenv "NET" with
  | "DIRECT" -> direct_stackv4_with_dhcp default_console tap0
  | _ -> socket_stackv4 default_console [Ipaddr.V4.any]
  with Not_found -> socket_stackv4 default_console [Ipaddr.V4.any]

let http = http_server (conduit_direct stack)

let () = register "cat-server" [
    main $ default_console $ http $ pics
  ]
