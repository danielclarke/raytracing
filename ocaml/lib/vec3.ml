type t =
  { x : float
  ; y : float
  ; z : float
  }

let ones = { x = 1.; y = 1.; z = 1. }
let zeros = { x = 0.; y = 0.; z = 0. }
let ( + ) u v = { x = u.x +. v.x; y = u.y +. v.y; z = u.z +. v.z }
let ( - ) u v = { x = u.x -. v.x; y = u.y -. v.y; z = u.z -. v.z }
let ( * ) scalar v = { x = v.x *. scalar; y = v.y *. scalar; z = v.z *. scalar }

let cross u v =
  { x = (u.y *. v.z) -. (u.z *. v.y)
  ; y = (u.z *. v.x) -. (u.x *. v.z)
  ; z = (u.x *. v.y) -. (u.y *. v.x)
  }


let dot u v = (u.x *. v.x) +. (u.y *. v.y) +. (u.z *. v.z)
let mag v = dot v v |> sqrt
let unit v = 1. /. mag v * v

let close_to_zero v =
  let epsilon = 1e-8 in
  abs_float v.x < epsilon && abs_float v.y < epsilon && abs_float v.z < epsilon


let reflect v ~normal = v - (2. *. dot v normal * normal)
let negate { x; y; z } = { x = -.x; y = -.y; z = -.z }
let print_vec3 v = Printf.printf "x = %F; y = %F; z = %F\n%!" v.x v.y v.z

let random_vec3_in_unit_sphere () =
  let r = Random.float 1.
  and theta = Random.float (2. *. Float.pi)
  and phi = Random.float (2. *. Float.pi) in
  { x = r *. sin phi *. cos theta; y = r *. sin phi *. sin theta; z = r *. cos phi }


let random_unit_vec3 () =
  { x = Random.float 1.; y = Random.float 1.; z = Random.float 1. } |> unit
