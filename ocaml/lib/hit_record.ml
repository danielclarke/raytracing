type t =
  { point : Point.t
  ; normal : Vec3.t
  ; material : Material.t
  ; t : float
  ; front_face : bool
  }

let qualified_hit_record r material point ~t ~outward_normal =
  let open Vec3 in
  let front_face = dot r.Ray.direction outward_normal < 0. in
  let normal =
    if front_face then
      outward_normal
    else
      -1. >>* outward_normal
  in
  { point; normal; material; t; front_face }
