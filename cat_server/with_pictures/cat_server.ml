open Lwt
open V1_LWT

module Main
    (C:CONSOLE)
    (S: Cohttp_lwt.Server)
    (FS: KV_RO)
= struct

  let start _console http pics =
    let read_fs name =
      FS.size pics name >>= function
      | `Error (FS.Unknown_key _) -> fail (Failure ("read " ^ name))
      | `Ok size ->
        FS.read pics name 0 (Int64.to_int size) >>= function
        | `Error (FS.Unknown_key _) -> fail (Failure ("read " ^ name))
        | `Ok bufs -> return (Cstruct.copyv bufs)
    in

    let handle_request _conn_id _request _body =
      read_fs "cats0.jpg"

      >>= fun pic ->
      S.respond_string ~status: `OK ~body:pic ()
    in
    http (`TCP 8080) (S.make ~callback:handle_request ())
end
