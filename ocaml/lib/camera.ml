type t =
  { lens_radius : float
  ; origin : Point.t
  ; horizontal : Vec3.t
  ; vertical : Vec3.t
  ; lower_left_corner : Point.t
  ; u : Vec3.t
  ; v : Vec3.t
  }

let make ~aspect ~aperture ~vertical_fov_rad ~origin ~focus_distance ~look_at ~v_up =
  let open Vec3 in
  let w = unit (Point.distance origin look_at) in
  let u = unit (cross v_up w) in
  let v = cross w u in
  let height = 2. *. tan (vertical_fov_rad /. 2.) in
  let width = aspect *. height in
  let horizontal = focus_distance *. width * u
  and vertical = focus_distance *. height * v in
  let camera_center_offset =
    (-0.5 * horizontal) + (-0.5 * vertical) + (-.focus_distance * w)
  in
  let lower_left_corner = Point.translate origin camera_center_offset in
  { lens_radius = aperture /. 2.; origin; horizontal; vertical; lower_left_corner; u; v }


let get_ray t ~u ~v =
  let open Vec3 in
  let rd = Point.random_point_in_unit_disc () in
  let offset = (rd.x *. t.lens_radius * t.u) + (rd.y *. t.lens_radius * t.v) in
  let direction =
    Point.distance
      (Point.translate t.lower_left_corner ((u * t.horizontal) + (v * t.vertical)))
      (Point.translate t.origin offset)
  in
  ({ origin = Point.translate t.origin offset; direction; color = Color.white } : Ray.t)
