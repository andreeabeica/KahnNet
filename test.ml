open Unix
let create_dialog readport obj1 obj2 =
  let envoyeur () = 
    let rec loop () = 
    let sock_addr = ADDR_INET (inet_addr_of_string "127.0.0.1", readport) in
    let sock_client = socket (domain_of_sockaddr sock_addr) SOCK_STREAM 0 in
      connect sock_client sock_addr; let chan = out_channel_of_descr sock_client in Marshal.to_channel chan obj1 [Marshal.Closures]; close_out chan; loop () 
    in loop () 
  in
    let sock_addr = ADDR_INET (inet_addr_of_string "127.0.0.1", readport) in
    let sock_serveur = socket (domain_of_sockaddr sock_addr) SOCK_STREAM 0 in
     bind sock_serveur sock_addr; listen sock_serveur 5; Thread.create envoyeur ();
     let rec loop () = let sockclient = fst (accept sock_serveur) in print_string "Nouveau client";
     let chan = in_channel_of_descr sockclient in
     let x = Marshal.from_channel chan in x=obj2; close_in chan; loop ()
     in loop ()

let _ = try create_dialog 10066 5 [5] with Unix_error (e,_,_) -> print_string (error_message e)
