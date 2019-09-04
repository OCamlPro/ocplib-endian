module BigEndian = struct

  type nonrec t = t

  let get_char = get_char
  let get_uint8 = get_uint8
  let get_int8 = get_int8
  let set_char = set_char
  let set_int8 = set_int8

#include "be_ocaml_400.ml"
#include "common_float.ml"

end

module BigEndian_unsafe = struct

  type nonrec t = t

  let get_char = unsafe_get_char
  let get_uint8 = unsafe_get_uint8
  let get_int8 = unsafe_get_int8
  let set_char = unsafe_set_char
  let set_int8 = unsafe_set_int8

#include "be_ocaml_400.ml"
#include "common_float.ml"

end

module LittleEndian = struct

  type nonrec t = t

  let get_char = get_char
  let get_uint8 = get_uint8
  let get_int8 = get_int8
  let set_char = set_char
  let set_int8 = set_int8

#include "le_ocaml_400.ml"
#include "common_float.ml"

end

module LittleEndian_unsafe = struct

  type nonrec t = t

  let get_char = unsafe_get_char
  let get_uint8 = unsafe_get_uint8
  let get_int8 = unsafe_get_int8
  let set_char = unsafe_set_char
  let set_int8 = unsafe_set_int8

#include "le_ocaml_400.ml"
#include "common_float.ml"

end

#if OCAML_VERSION >= (4, 00, 0)
module NativeEndian = struct

  type nonrec t = t

  let get_char = get_char
  let get_uint8 = get_uint8
  let get_int8 = get_int8
  let set_char = set_char
  let set_int8 = set_int8

#include "ne_ocaml_400.ml"
#include "common_float.ml"

end

module NativeEndian_unsafe = struct

  type nonrec t = t

  let get_char = unsafe_get_char
  let get_uint8 = unsafe_get_uint8
  let get_int8 = unsafe_get_int8
  let set_char = unsafe_set_char
  let set_int8 = unsafe_set_int8

#include "ne_ocaml_400.ml"
#include "common_float.ml"

end
#endif
