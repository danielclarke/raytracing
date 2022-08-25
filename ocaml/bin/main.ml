open Raytracer

let rec from i j l = if i > j then l else from i (j - 1) (j :: l)
let ( -- ) i j = from i j []

let rec ray_color ray world depth =
  if depth <= 0 then
    Color.black
  else (
    match World.hit world ray ~t_min:0.001 ~t_max:Float.infinity with
    | None ->
      let fraction = (Vec3.unit ray.Ray.direction).y *. 0.5 in
      Color.lerp ~u:Color.white ~v:(Color.from_rgb ~r:0.5 ~g:0.7 ~b:1.0) ~fraction
    | Some hit_record ->
      (match Ray_physics.scatter ray hit_record with
      | None -> Color.black
      | Some scattered_ray ->
        Color.combine scattered_ray.color (ray_color scattered_ray world (depth - 1))))


let scene_camera aspect =
  Camera.make
    ~aspect
    ~focal_length:1.0
    ~vertical_fov_rad:(Float.pi /. 2.)
    ~origin:Point.origin


let print_pixel_color ~camera ~world ~depth ~samples ~im_width ~im_height x y =
  let single_sample () =
    let ray =
      Camera.get_ray
        camera
        ~u:((Int.to_float x +. Random.float 1.) /. Int.to_float im_width)
        ~v:((Int.to_float y +. Random.float 1.) /. Int.to_float im_height)
    in
    ray_color ray world depth
  in
  List.map (fun _ -> single_sample ()) (0 -- (samples - 1))
  |> List.fold_left Color.add Color.black
  |> Color.ppm ~samples
  |> Printf.printf "%s\n%!"


let make_world =
  World.make
    [ { center = { x = 0.; y = 0.0; z = -1.0 }
      ; radius = 0.5
      ; material = Material.Metal { aldebo = Color.white; fuzz = 0. }
      }
    ; { center = { x = 0.; y = -1000.5; z = -1.0 }
      ; radius = 1000.0
      ; material = Material.Lambertian { aldebo = Color.from_rgb ~r:0.1 ~g:0.2 ~b:0.5 }
      }
    ]


(* let hw_image ~im_width ~im_height x y =
  Printf.printf
    "%s\n%!"
    (Color.ppm
       (Color.from_rgb
          ~r:(Int.to_float x /. Int.to_float im_width)
          ~g:(Int.to_float y /. Int.to_float im_height)
          ~b:0.25)
       ~samples:1) *)

let () =
  let depth = 500
  and samples = 100
  and aspect = 16. /. 9.
  and im_width = 400 in
  let im_height = Float.to_int (Int.to_float im_width /. aspect)
  and camera = scene_camera aspect
  and world = make_world in
  let row = 0 -- (im_width - 1)
  and column = List.rev (0 -- (im_height - 1)) in
  let printer = print_pixel_color ~camera ~world ~depth ~samples ~im_width ~im_height in
  (* let printer = hw_image ~im_width ~im_height in *)
  Printf.printf "P3\n%s %s\n255\n" (Int.to_string im_width) (Int.to_string im_height);
  List.iter (fun y -> List.iter (fun x -> printer x y) row) column
