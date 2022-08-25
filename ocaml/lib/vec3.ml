type t =
  { x : float
  ; y : float
  ; z : float
  }

let ones = { x = 1.; y = 1.; z = 1. }
let zeros = { x = 0.; y = 0.; z = 0. }

let random_vec3_in_unit_sphere () =
  let r = Random.float 1.
  and theta = Random.float (2. *. Float.pi)
  and phi = Random.float (2. *. Float.pi) in
  { x = r *. sin phi *. cos theta; y = r *. sin phi *. sin theta; z = r *. cos phi }


let ( >>+ ) u v = { x = u.x +. v.x; y = u.y +. v.y; z = u.z +. v.z }
let ( >>- ) u v = { x = u.x -. v.x; y = u.y -. v.y; z = u.z -. v.z }
let ( >>/ ) v f = { x = v.x /. f; y = v.y /. f; z = v.z /. f }
let ( >>* ) f v = { x = v.x *. f; y = v.y *. f; z = v.z *. f }
let dot u v = (u.x *. v.x) +. (u.y *. v.y) +. (u.z *. v.z)
let mag v = dot v v |> sqrt
let unit v = v >>/ mag v

let close_to_zero v =
  let epsilon = 1e-8 in
  abs_float v.x < epsilon && abs_float v.y < epsilon && abs_float v.z < epsilon


let reflect v ~normal = v >>- (2. *. dot v normal >>* normal)
let print_vec3 v = Printf.printf "x = %F; y = %F; z = %F\n%!" v.x v.y v.z
