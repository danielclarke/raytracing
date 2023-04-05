type t =
  { origin : Point.t
  ; direction : Vec3.t
  ; color : Color.t
  }

let at t f =
  let v = Vec3.scale f t.direction in
  Point.translate t.origin v
