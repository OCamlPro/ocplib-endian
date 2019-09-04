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

module type EndianBytesSig = sig
  include EndianSig.RW with type t = Bytes.t
end

module BigEndian : sig
  (** Functions reading according to Big Endian byte order without
  checking for overflow *)

  include EndianBytesSig

end

module BigEndian_unsafe : sig
  (** Functions reading according to Big Endian byte order without
  checking for overflow *)

  include EndianBytesSig

end

module LittleEndian : sig
  (** Functions reading according to Little Endian byte order *)

  include EndianBytesSig

end

module LittleEndian_unsafe : sig
  (** Functions reading according to Big Endian byte order without
  checking for overflow *)

  include EndianBytesSig

end

#if OCAML_VERSION >= (4, 00, 0)
module NativeEndian : sig
  (** Functions reading according to machine endianness *)

  include EndianBytesSig

end

module NativeEndian_unsafe : sig
  (** Functions reading according to machine endianness without
  checking for overflow *)

  include EndianBytesSig

end
#endif
