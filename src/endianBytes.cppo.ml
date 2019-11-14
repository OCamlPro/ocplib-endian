(************************************************************************)
(*  ocplib-endian                                                       *)
(*                                                                      *)
(*    Copyright 2014 OCamlPro                                           *)
(*                                                                      *)
(*  This file is distributed under the terms of the GNU Lesser General  *)
(*  Public License as published by the Free Software Foundation; either *)
(*  version 2.1 of the License, or (at your option) any later version,  *)
(*  with the OCaml static compilation exception.                        *)
(*                                                                      *)
(*  ocplib-endian is distributed in the hope that it will be useful,    *)
(*  but WITHOUT ANY WARRANTY; without even the implied warranty of      *)
(*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the       *)
(*  GNU General Public License for more details.                        *)
(*                                                                      *)
(************************************************************************)

type t = Bytes.t

module type EndianBytesSig = sig
  include EndianSig.FULL with type t = Bytes.t
end

let get_char (s:Bytes.t) off =
  Bytes.get s off
let set_char (s:Bytes.t) off v =
  Bytes.set s off v
let unsafe_get_char (s:Bytes.t) off =
  Bytes.unsafe_get s off
let unsafe_set_char (s:Bytes.t) off v =
  Bytes.unsafe_set s off v

#include "common.ml"

#if OCAML_VERSION >= (4, 01, 0)

external unsafe_get_16 : Bytes.t -> int -> int = "%caml_string_get16u"
external unsafe_get_32 : Bytes.t -> int -> int32 = "%caml_string_get32u"
external unsafe_get_64 : Bytes.t -> int -> int64 = "%caml_string_get64u"

external unsafe_set_16 : Bytes.t -> int -> int -> unit = "%caml_string_set16u"
external unsafe_set_32 : Bytes.t -> int -> int32 -> unit = "%caml_string_set32u"
external unsafe_set_64 : Bytes.t -> int -> int64 -> unit = "%caml_string_set64u"

external get_16 : Bytes.t -> int -> int = "%caml_string_get16"
external get_32 : Bytes.t -> int -> int32 = "%caml_string_get32"
external get_64 : Bytes.t -> int -> int64 = "%caml_string_get64"

external set_16 : Bytes.t -> int -> int -> unit = "%caml_string_set16"
external set_32 : Bytes.t -> int -> int32 -> unit = "%caml_string_set32"
external set_64 : Bytes.t -> int -> int64 -> unit = "%caml_string_set64"

#include "common_401.ml"

#else

#include "common_400.ml"

#endif
