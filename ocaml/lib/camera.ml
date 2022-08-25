type t =
  { aspect : float
  ; height : float
  ; width : float
  ; focal_length : float
  ; origin : Point.t
  ; horizontal : Vec3.t
  ; vertical : Vec3.t
  ; lower_left_corner : Point.t
  }

let make ~aspect ~focal_length ~vertical_fov_rad ~origin =
  let open Vec3 in
  let height = 2. *. tan (vertical_fov_rad /. 2.) in
  let width = aspect *. height in
  let horizontal = { x = width; y = 0.; z = 0. }
  and vertical = { x = 0.; y = height; z = 0. } in
  let camera_center = { x = width /. 2.; y = height /. 2.; z = focal_length } in
  let lower_left_corner = Point.translate origin (-1. >>* camera_center) in
  { aspect; height; width; focal_length; origin; horizontal; vertical; lower_left_corner }


let get_ray t ~u ~v =
  let open Vec3 in
  let direction =
    Point.distance
      (Point.translate t.lower_left_corner (u >>* t.horizontal >>+ (v >>* t.vertical)))
      t.origin
  in
  ({ origin = t.origin; direction; color = Color.white } : Ray.t)
