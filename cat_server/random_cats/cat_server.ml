open Lwt
open V1_LWT

module Main
    (C:CONSOLE)
    (S: Cohttp_lwt.Server)
    (FS: KV_RO)
= struct

  let start console http pics =

    Random.self_init ();

    let read_fs name =
      FS.size pics name >>= function
      | `Error (FS.Unknown_key _) -> fail (Failure ("read " ^ name))
      | `Ok size ->
        FS.read pics name 0 (Int64.to_int size) >>= function
        | `Error (FS.Unknown_key _) -> fail (Failure ("read " ^ name))
        | `Ok bufs -> return (Cstruct.copyv bufs)
    in

    let cat_utterances = ["Miaouw"; "Purrrr"; "Nyan"] in

    let get_index_page () = Printf.sprintf
        "<html>\
         <head><title>CatServer</title></head>\
         <body><img src=\"/cats/random\" /><h1>%s</h1></body>\
         </html>" (List.nth cat_utterances (Random.int 3))
    in

    let get_path request = Uri.path (Cohttp.Request.uri request) in

    let handle_request conn_id request body =
      match get_path request with
      | "/" -> S.respond_string ~status:`OK ~body:(get_index_page ()) ()
      | "/cats/random" ->
        read_fs (Printf.sprintf "cats%d.jpg" (Random.int 3))
        >>= fun pic -> S.respond_string ~status:`OK ~body:pic ()
      | _ -> S.respond_not_found ()
    in
    http (`TCP 8080) (S.make ~callback:handle_request ())
end
