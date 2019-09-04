open EndianBytes

let to_t x = x
(* do not allocate to avoid breaking tests *)

module BE = BigEndian
module LE = LittleEndian
#if OCAML_VERSION >= (4, 00, 0)
module NE = NativeEndian
#endif

#if OCAML_VERSION >= (4, 00, 0)
let big_endian = Sys.big_endian
#else
(* Sys.big_endian is not available on ocaml <= 3.12 *)
#endif

let s = Bytes.make 10 '\x00'

let assert_bound_check2 f v1 v2 =
  try
    ignore(f v1 v2);
    assert false
  with
     | Invalid_argument _ -> ()

let assert_bound_check3 f v1 v2 v3 =
  try
    ignore(f v1 v2 v3);
    assert false
  with
     | Invalid_argument _ -> ()

let test1 () =
  assert_bound_check2 BE.get_int8 (to_t s) (-1);
  assert_bound_check2 BE.get_int8 (to_t s) 10;
  assert_bound_check2 BE.get_uint16 (to_t s) (-1);
  assert_bound_check2 BE.get_uint16 (to_t s) 9;
  assert_bound_check2 BE.get_int32 (to_t s) (-1);
  assert_bound_check2 BE.get_int32 (to_t s) 7;
  assert_bound_check2 BE.get_int64 (to_t s) (-1);
  assert_bound_check2 BE.get_int64 (to_t s) 3;

  assert_bound_check3 BE.set_int8 s (-1) 0;
  assert_bound_check3 BE.set_int8 s 10 0;
  assert_bound_check3 BE.set_int16 s (-1) 0;
  assert_bound_check3 BE.set_int16 s 9 0;
  assert_bound_check3 BE.set_int32 s (-1) 0l;
  assert_bound_check3 BE.set_int32 s 7 0l;
  assert_bound_check3 BE.set_int64 s (-1) 0L;
  assert_bound_check3 BE.set_int64 s 3 0L

let test2 () =
  BE.set_int8 s 0 63; (* in [0; 127] *)
  assert( BE.get_uint8 (to_t s) 0 = 63 );
  assert( BE.get_int8 (to_t s) 0 = 63 );

  BE.set_int8 s 0 155; (* in [128; 255] *)
  assert( BE.get_uint8 (to_t s) 0 = 155 );

  BE.set_int8 s 0 (-103); (* in [-128; -1] *)
  assert( BE.get_int8 (to_t s) 0 = (-103) );

  BE.set_int8 s 0 0x1234; (* outside of the [-127;255] range *)
  assert( BE.get_uint8 (to_t s) 0 = 0x34 );
  assert( BE.get_int8 (to_t s) 0 = 0x34 );

  BE.set_int8 s 0 0xAACD; (* outside of the [-127;255] range, -0x33 land 0xFF = 0xCD*)
  assert( BE.get_uint8 (to_t s) 0 = 0xCD );
  assert( BE.get_int8 (to_t s) 0 = (-0x33) );

  BE.set_int16 s 0 0x1234;
  assert( BE.get_uint16 (to_t s) 0 = 0x1234 );
  assert( BE.get_uint16 (to_t s) 1 = 0x3400 );
  assert( BE.get_uint16 (to_t s) 2 = 0 );

  assert( LE.get_uint16 (to_t s) 0 = 0x3412 );
  assert( LE.get_uint16 (to_t s) 1 = 0x0034 );
  assert( LE.get_uint16 (to_t s) 2 = 0 );

#if OCAML_VERSION >= (4, 00, 0)
  if big_endian then begin
    assert( BE.get_uint16 (to_t s) 0 = NE.get_uint16 (to_t s) 0 );
    assert( BE.get_uint16 (to_t s) 1 = NE.get_uint16 (to_t s) 1 );
    assert( BE.get_uint16 (to_t s) 2 = NE.get_uint16 (to_t s) 2 );
  end
  else begin
    assert( LE.get_uint16 (to_t s) 0 = NE.get_uint16 (to_t s) 0 );
    assert( LE.get_uint16 (to_t s) 1 = NE.get_uint16 (to_t s) 1 );
    assert( LE.get_uint16 (to_t s) 2 = NE.get_uint16 (to_t s) 2 );
  end;
#endif

  assert( BE.get_int16 (to_t s) 0 = 0x1234 );
  assert( BE.get_int16 (to_t s) 1 = 0x3400 );
  assert( BE.get_int16 (to_t s) 2 = 0 );

  BE.set_int16 s 0 0xFEDC;
  assert( BE.get_uint16 (to_t s) 0 = 0xFEDC );
  assert( BE.get_uint16 (to_t s) 1 = 0xDC00 );
  assert( BE.get_uint16 (to_t s) 2 = 0 );

  assert( LE.get_uint16 (to_t s) 0 = 0xDCFE );
  assert( LE.get_uint16 (to_t s) 1 = 0x00DC );
  assert( LE.get_uint16 (to_t s) 2 = 0 );

#if OCAML_VERSION >= (4, 00, 0)
  if big_endian then begin
    assert( BE.get_uint16 (to_t s) 0 = NE.get_uint16 (to_t s) 0 );
    assert( BE.get_uint16 (to_t s) 1 = NE.get_uint16 (to_t s) 1 );
    assert( BE.get_uint16 (to_t s) 2 = NE.get_uint16 (to_t s) 2 );
  end
  else begin
    assert( LE.get_uint16 (to_t s) 0 = NE.get_uint16 (to_t s) 0 );
    assert( LE.get_uint16 (to_t s) 1 = NE.get_uint16 (to_t s) 1 );
    assert( LE.get_uint16 (to_t s) 2 = NE.get_uint16 (to_t s) 2 );
  end;
#endif

  assert( BE.get_int16 (to_t s) 0 = -292 );
  assert( BE.get_int16 (to_t s) 1 = -9216 );
  assert( BE.get_int16 (to_t s) 2 = 0 );

#if OCAML_VERSION >= (4, 00, 0)
  if big_endian
  then begin
    NE.set_int16 s 0 0x1234;
    assert( BE.get_uint16 (to_t s) 0 = 0xFEDC );
    assert( BE.get_uint16 (to_t s) 1 = 0xDC00 );
    assert( BE.get_uint16 (to_t s) 2 = 0 )
  end;
#endif

  LE.set_int16 s 0 0x1234;
  assert( BE.get_uint16 (to_t s) 0 = 0x3412 );
  assert( BE.get_uint16 (to_t s) 1 = 0x1200 );
  assert( BE.get_uint16 (to_t s) 2 = 0 );

#if OCAML_VERSION >= (4, 00, 0)
  if not big_endian
  then begin
    NE.set_int16 s 0 0x1234;
    assert( BE.get_uint16 (to_t s) 0 = 0x3412 );
    assert( BE.get_uint16 (to_t s) 1 = 0x1200 );
    assert( BE.get_uint16 (to_t s) 2 = 0 )
  end;
#endif

  LE.set_int16 s 0 0xFEDC;
  assert( LE.get_uint16 (to_t s) 0 = 0xFEDC );
  assert( LE.get_uint16 (to_t s) 1 = 0x00FE );
  assert( LE.get_uint16 (to_t s) 2 = 0 );

  BE.set_int32 s 0 0x12345678l;
  assert( BE.get_int32 (to_t s) 0 = 0x12345678l );
  assert( LE.get_int32 (to_t s) 0 = 0x78563412l );
#if OCAML_VERSION >= (4, 00, 0)
  if big_endian
  then assert( BE.get_int32 (to_t s) 0 = NE.get_int32 (to_t s) 0 )
  else assert( LE.get_int32 (to_t s) 0 = NE.get_int32 (to_t s) 0 );
#endif

  LE.set_int32 s 0 0x12345678l;
  assert( LE.get_int32 (to_t s) 0 = 0x12345678l );
  assert( BE.get_int32 (to_t s) 0 = 0x78563412l );

#if OCAML_VERSION >= (4, 00, 0)
  if big_endian
  then assert( BE.get_int32 (to_t s) 0 = NE.get_int32 (to_t s) 0 )
  else assert( LE.get_int32 (to_t s) 0 = NE.get_int32 (to_t s) 0 );

  NE.set_int32 s 0 0x12345678l;
  if big_endian
  then assert( BE.get_int32 (to_t s) 0 = 0x12345678l )
  else assert( LE.get_int32 (to_t s) 0 = 0x12345678l );
#endif

  ()

let test_64 () =
  BE.set_int64 s 0 0x1234567890ABCDEFL;
  assert( BE.get_int64 (to_t s) 0 = 0x1234567890ABCDEFL );
  assert( LE.get_int64 (to_t s) 0 = 0xEFCDAB9078563412L );

#if OCAML_VERSION >= (4, 00, 0)
  if big_endian
  then assert( BE.get_int64 (to_t s) 0 = NE.get_int64 (to_t s) 0 )
  else assert( LE.get_int64 (to_t s) 0 = NE.get_int64 (to_t s) 0 );
#endif

  LE.set_int64 s 0 0x1234567890ABCDEFL;
  assert( LE.get_int64 (to_t s) 0 = 0x1234567890ABCDEFL );
  assert( BE.get_int64 (to_t s) 0 = 0xEFCDAB9078563412L );

#if OCAML_VERSION >= (4, 00, 0)
  if big_endian
  then assert( BE.get_int64 (to_t s) 0 = NE.get_int64 (to_t s) 0 )
  else assert( LE.get_int64 (to_t s) 0 = NE.get_int64 (to_t s) 0 );

  NE.set_int64 s 0 0x1234567890ABCDEFL;
  if big_endian
  then assert( BE.get_int64 (to_t s) 0 = 0x1234567890ABCDEFL )
  else assert( LE.get_int64 (to_t s) 0 = 0x1234567890ABCDEFL );
#endif

  ()
