type t =
  { x : float
  ; y : float
  ; z : float
  }

let origin = { x = 0.; y = 0.; z = 0. }

let random_point_in_unit_sphere () =
  let r = Random.float 1.
  and theta = Random.float (2. *. Float.pi)
  and phi = Random.float (2. *. Float.pi) in
  { x = r *. sin phi *. cos theta; y = r *. sin phi *. sin theta; z = r *. cos phi }


let translate t v =
  let { x; y; z } = t
  and ({ x = u; y = v; z = w } : Vec3.t) = v in
  { x = u +. x; y = v +. y; z = w +. z }


let distance t t' =
  let { x; y; z } = t
  and { x = x'; y = y'; z = z' } = t' in
  ({ x = x -. x'; y = y -. y'; z = z -. z' } : Vec3.t)
