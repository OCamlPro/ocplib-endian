
let allocdiff =
  let stat1 = Gc.quick_stat () in
  let stat2 = Gc.quick_stat () in
  (stat2.Gc.minor_words -. stat1.Gc.minor_words)

let version_over req_major req_minor =
  try
    Scanf.sscanf Sys.ocaml_version "%i.%i.%i"
      (fun major minor patch -> major > req_major || (major = req_major && minor >= req_minor))
  with _ -> false

let () =
  Test_bigstring.test1 ();
  let stat1 = Gc.quick_stat () in
  Test_bigstring.test2 ();
  if Sys.word_size = 64 then Test_bigstring.test_64 ();
  let stat2 = Gc.quick_stat () in
  (* with a 32 bit system, int64 must be heap allocated *)
  if Sys.word_size = 32 then Test_bigstring.test_64 ();
  let alloc1 = stat2.Gc.minor_words -. stat1.Gc.minor_words -. allocdiff in
  Printf.printf "bigstring: allocated words %f\n%!" alloc1;

  Test_string.test1 ();
  let stat1 = Gc.quick_stat () in
  Test_string.test2 ();
  if Sys.word_size = 64 then Test_string.test_64 ();
  let stat2 = Gc.quick_stat () in
  if Sys.word_size = 32 then Test_string.test_64 ();
  let alloc2 = stat2.Gc.minor_words -. stat1.Gc.minor_words -. allocdiff in
  Printf.printf "string: allocated words %f\n%!" alloc2;

  Test_bytes.test1 ();
  let stat1 = Gc.quick_stat () in
  Test_bytes.test2 ();
  if Sys.word_size = 64 then Test_string.test_64 ();
  let stat2 = Gc.quick_stat () in
  if Sys.word_size = 32 then Test_string.test_64 ();
  let alloc3 = stat2.Gc.minor_words -. stat1.Gc.minor_words -. allocdiff in
  Printf.printf "bytes: allocated words %f\n%!" alloc3;
  (* we cannot ensure that there are no allocations only with the
     primives added in 4.01.0 *)
  let failure =
    if version_over 4 3 then
      (alloc1 <> 0. || alloc2 <> 0. || alloc3 <> 0.)
    else if version_over 4 1 then
      (alloc1 <> 72. || alloc2 <> 72. || alloc3 <> 72.)
    else
      false
  in
  exit (if failure then 1 else 0)
