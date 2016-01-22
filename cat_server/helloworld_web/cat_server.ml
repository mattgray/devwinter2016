open Lwt
open V1_LWT

module Main (C:CONSOLE) (S: STACKV4) = struct
  let on_error_close = fun console flow ->
    C.log console "An error occured"; S.TCPV4.close flow

  let http_response = "HTTP 1.0 200 OK\r\nContent-Type:
    text/html\r\n\r\n<html><body><h1>Hello world!</h1></body></html>"

  let send_response = fun console flow ->
    S.TCPV4.write flow (Cstruct.of_string http_response)
       >>= fun result -> match result with
        | `Eof | `Error _ -> on_error_close console flow
        | `Ok () -> C.log console "Served one cat request."; S.TCPV4.close flow

  let handle_request = fun console flow ->
    S.TCPV4.read flow
      >>= fun result -> match result with
        | `Eof | `Error _ -> on_error_close console flow
        | `Ok buffer ->
          C.log console (Cstruct.to_string buffer);
          send_response console flow

  let start console stackv4 =
    S.listen_tcpv4 stackv4 8080 (handle_request console);

    S.listen stackv4
end
