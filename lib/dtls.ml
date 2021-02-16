module Version = struct 
  type t = [ `DTLS_1_0 | `DTLS_1_2 ] [@@deriving sexp]

  let tls_version = function 
    | `DTLS_1_0 -> `TLS_1_1
    | `DTLS_1_2 -> `TLS_1_2

  let to_pair = function 
    | `DTLS_1_0 -> (254, 255)
    | `DTLS_1_2 -> (254, 253)

  let of_pair = function 
    | (254, 255) -> Some `DTLS_1_0
    | (254, 253) -> Some `DTLS_1_2
    | _ -> None

  let is_dtls = function 
    | #t -> true 
    | _  -> false

  let compare a b = match a, b with
    | `DTLS_1_0, `DTLS_1_0 -> 0
    | `DTLS_1_0, `DTLS_1_2 -> -1 
    | `DTLS_1_2, `DTLS_1_2 -> 0
    | `DTLS_1_2, `DTLS_1_0 -> 1

  let next = function 
    | `DTLS_1_0 -> Some `DTLS_1_2
    | _ -> None
end 

module Utils = struct 
  (* TODO: Check this works... *)
  let get_uint48 buf off =
    Int64.(
      add
        (mul (of_int32 @@ Cstruct.BE.get_uint32 buf (off)) 0x10000L)
        (Int64.of_int @@ Cstruct.BE.get_uint16 buf (4 + off)))
end 

