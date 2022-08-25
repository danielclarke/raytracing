open OUnit2
open Raytracer

let color_tests =
  "test suite for color"
  >::: [ ("ppm white"
         >:: fun _ -> assert_equal "255 255 255" (Color.ppm Color.white ~samples:1))
       ; ("ppm black" >:: fun _ -> assert_equal "0 0 0" (Color.ppm Color.black ~samples:1))
       ; ("lerp black white"
         >:: fun _ ->
         let result = Color.lerp ~u:Color.black ~v:Color.white ~fraction:0.5 in
         print_endline (Color.to_string result);
         assert_equal (Color.from_rgb ~r:0.5 ~g:0.5 ~b:0.5) result)
       ]


let _ = run_test_tt_main color_tests
