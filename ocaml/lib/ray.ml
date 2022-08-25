type t =
  { origin : Point.t
  ; direction : Vec3.t
  ; color : Color.t
  }

let at t f =
  let open Vec3 in
  let v = f >>* t.direction in
  Point.translate t.origin v
