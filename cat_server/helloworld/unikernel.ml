open Lwt
open V1_LWT

module Main (C:CONSOLE) = struct

  let start console =
    OS.Time.sleep 2.0
    >>= fun () ->
    C.log_s console "Hello devwinter !"
end
